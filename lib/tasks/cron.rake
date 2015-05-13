namespace :cron do

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
#			File.delete(Rails.root.join('receiveds', fichier))

			#On vérifie si il s'agit d'une commande (format = login:password:commande:arguments)
			sms_content = file_content[1].split(/(?<!\\):/, 4)
			command = Command.find_by_name(sms_content[2])	

			#Si il s'agit d'une commande (résultat non vide)
			if !command.nil?
				puts "    This SMS is a command"

				#On vérifie si l'utilisateur est bon
				user = User.find_by_email(sms_content[0])
				user_is_valid = user.valid_password?(sms_content[1])				

				sms_content[1] = "*****" #On remplace le password

				if user_is_valid
					if (command.admin && user.admin) || !command.admin
						puts "    User is valid"
						commands_to_run << {:command_name => sms_content[2], :command_arguments => sms_content[3]}
					else
						puts "    But user is invalid"
					end

				end
			end

			puts "SMS saved : " + sms_content.join(':')
			#On enregistre la reception
			received = Received.create(:send_by => file_content[0], :content => sms_content.join(':'), :is_command => !command.nil?)
		end

		puts "All SMS parsed"
	end
end
