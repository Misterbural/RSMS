namespace :cron do
	desc "Permet d'envoyer les SMS programmés"
	task :send => :environment do
		
		#On passe tous les SMS non encore envoyé en IN progress
		scheduleds = Scheduled.where(['progress = :progress AND send_at < datetime()', { progress: 0 }])

		if scheduleds.nil?
			exit
		end

		scheduleds.each do |scheduled|
			puts "#{scheduled.id} is now in progress"
			scheduled.update_attribute(:progress, true)
		end

		#On passe sur chaque SMS programmé
		scheduleds.each do |scheduled|
			target_numbers = []

			#On recupère tous les numéros
			numbers = NumbersScheduled.where(['scheduled_id = :scheduled_id', { scheduled_id: scheduled.id }])

			numbers.each do |number|
				target_numbers << number.number
			end

			target_numbers.each do |target_number|
				puts target_number
			end

			target_numbers.each do |target_number|
				puts "Envoie du SMS numéro #{scheduled.id} au #{target_number}"
				system('gammu-smsd-inject', " TEXT #{target_number} -len #{scheduled.content.length} #{scheduled.content}")
			end
		end
	end

	desc "Permet d'enregistrer les SMS reçus !"
	task :receive => :environment do 
		commands_to_run = [];
		Dir.foreach Rails.root.join('receiveds') do |fichier|
			if fichier == "." || fichier == ".."
				next
			end

			puts "Traitement du SMS " + fichier
			
			#on ouvre le fichier et on recupere le numéro et le contenu
			file = File.open(Rails.root.join('receiveds', fichier), 'r')
			file_content_text = file.read
			file_content = file_content_text.split(':', 2)
			file.close

			#On supprime le fichier
			File.delete(Rails.root.join('receiveds', fichier))

			#On vérifie si il s'agit d'une commande (format = login:password:commande:arguments)
			sms_content = file_content[1].split(/(?<!\\):/, 4)
			command = Command.find_by_name(sms_content[2])	

			#Si il s'agit d'une commande (résultat non vide)
			if !command.nil?
				puts "    This SMS is a command"

				#On vérifie si l'utilisateur est bon
				user = User.find_by_email(sms_content[0])
				
				if !user.nil?
					user_is_valid = user.valid_password?(sms_content[1])				
				end

				sms_content[1] = "*****" #On remplace le password

				if user_is_valid
					if (command.admin && user.admin) || !command.admin
						puts "    User is valid"
						commands_to_run << {:command_name => sms_content[2], :script_file => command.script, :command_arguments => sms_content[3]}
					else
						puts "    But user is invalid"
					end

				else
					puts "    But user is invalid"
				end
			end

			puts "SMS saved : " + sms_content.join(':')
			#On enregistre la reception
			received = Received.create(:send_by => file_content[0], :content => sms_content.join(':'), :is_command => !command.nil?)
		end

		commands_to_run.each do |command|
			script_path = Rails.root.join('scripts', command[:script_file]).to_s
			script_arguments = command[:command_arguments]
			puts "Running command : #{script_path} #{script_arguments}"
			system(script_path, script_arguments)
			puts "Command finish"
		end

		puts "All SMS parsed, all traitements done !"
	end
end
