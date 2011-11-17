module Bayes
	class BayesTraining
	attr_accessor :emails, :spam, :wordsSpam, :wordsNoSpam  

	def initialize(emails,spam)
		@emails = emails
		@spam = spam
		@wordsSpam = initializeWordsN
		@wordsNoSpam = initializeWords
	end

	def initializeWords
	 words = []
	 @emails.each do |email|
	 	email.each do |word|
	 	 words <<{ :word=> word, :occurrence => 0.0, :probability => 0.0}
	 	end
	 end
	 words.uniq!
	end

	def initializeWordsN
	 words = []
	 @spam.each do |email|
	 	email.each do |word|
		 words << { :word=> word, :occurrence => 0.0,:probability => 0.0}
	 	end
	 end
	 words.uniq!
	end

	def clasification
		calculateProbability
		changeProbability
		while(existOc?)
		deleteWords(@wordsNoSpam, @wordsSpam)     #elimina las que no utilizaremos ocurrencia < 3
		end
		writeFile
	end

	def existOc?
		@wordsSpam.each do |word|
			if (word[:occurrence] <=3)
			return true
			end
		end
	
		@wordsNoSpam.each do |word|
			if (word[:occurrence] <=3)
			return true
			end
		end
		return false
	end
	
	

	def calculateProbability
			@wordsNoSpam.each do |linea|
			 ocurrCant = occurrenceAmount(@emails,linea[:word])
			 changeOccurrence(ocurrCant,@wordsNoSpam,linea[:word])
			end
			@wordsSpam.each do |linea|
			 ocurrCant = occurrenceAmount(@spam,linea[:word])
			 changeOccurrence(ocurrCant,@wordsSpam,linea[:word])
			end
	end
	
	def occurrenceAmount(emails,word)
	  cant = 0
		emails.each do |mail|
			mail.each do |word1|
			cant +=1 if(word == word1)
		  end
		end
		cant
	end

	def changeOccurrence(cant,words,word)
		words.each_index do |i|
			if(words[i][:word] == word)
			words[i][:occurrence] = cant
		  end
		end
	end

	def changeProbability
		size_spam   = (@spam.count).to_f
		size_emails = (@emails.count).to_f

		@wordsNoSpam.each do |word|
			occSpam = findOcurrence(word[:word],@wordsSpam)
			
			if (occSpam == 0.0)
				word[:probability] =(word[:occurrence] /size_emails) /((word[:occurrence] /size_emails) + (0.01 / ((@wordsSpam.count / 10) +1)))
		  else 
			word[:probability] = (word[:occurrence] /size_emails) / ((occSpam/size_spam)+ (word[:occurrence] /size_emails))
		  end
		  end

		@wordsSpam.each do |word|
			occNoSpam = findOcurrence(word[:word],@wordsNoSpam)
			if (occNoSpam == 0.0)
				word[:probability] =(word[:occurrence] /size_spam) /((word[:occurrence] /size_spam) + (0.01 / ((@wordsNoSpam.count / 10) +1)))
		  else 
			word[:probability] = (word[:occurrence] /size_spam) / ((occNoSpam/size_emails)+ (word[:occurrence] /size_spam))
		  end
		  end
	end

	def findOcurrence(word,words)
		words.each do |word1|
			if(word1[:word] == word)
				return word1[:occurrence]
			end
		end
		0.0
	end

	def deleteWords(words1,words2)
		words1.each do |word|
			if (word[:occurrence] <= 3)
			words1.delete(word)
			end
		end
		words2.each do |word|
			if (word[:occurrence] <= 3)
			words2.delete(word)
			end
		end
	end
	
  def writeFile
    File.delete('PalabrasSpam.txt') if File.exist?('palabrasSpam.txt')
    File.delete('PalabrasNoSpam.txt')if File.exist?('palabrasNoSpam.txt')
    File.open('PalabrasSpam.txt', 'w') do |f2|
     f2.puts (@wordsSpam)
    end
    File.open('PalabrasNoSpam.txt', 'w') do |f2|
     f2.puts (@wordsNoSpam)
    end
  end
	
	
	end
end
