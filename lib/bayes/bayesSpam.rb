module Bayes
	class BayesSpam
	attr_accessor :email, :classBayesTraining, :floorProbability, :spam, :emailU, :value	 

	def initialize(email,classBayesTraining)
		@floorProbability = 0.5
		@classBayesTraining = classBayesTraining #datos de las palabras almacenados en el entrenamiento
		@email = intitializeMail(email)
		@emailU = []
		setProbability
		correct
		extractMoreSignificant
		probability
	end
	
	
	def intitializeMail(email)
		e_mail=[]
		email.each do |word|
			e_mail << {:word => word, :spamProbability => 0.0, :probability => 0.0}
		end
		e_mail.uniq
	end

	def setProbability
		@email.each do |word|
			word[:probability] = findProbability(word[:word],true)
			word[:spamProbability] = findProbability(word[:word],false)
		end
	end

	def findProbability(word,bool)
		if(bool==true)
	  wordsNoSpam = @classBayesTraining.wordsNoSpam
		wordsNoSpam.each do |word1|
			if(word1[:word] == word)
				return word1[:probability]
			end
		end
		else
		wordsSpam = @classBayesTraining.wordsSpam
		wordsSpam.each do |word1|
			if(word1[:word] == word)
				return word1[:probability]
			end
		end
		end
		#si no esta le asignamos la probabilidad de piso
		@floorProbability
	end

	def correct
		@email.each do |word|
			if(word[:spamProbability] != 0.0 && word[:probability] == @floorProbability)
			word[:probability] = 1-word[:spamProbability]
			else
			if(word[:spamProbability] == @floorProbability && word[:probability] != 0.0)
			word[:spamProbability] = 1-word[:probability]
			end
			end
		end
end

	def extractMoreSignificant
		@email.each do |word|
			if ((word[:spamProbability] >= 0.9 && word[:probability] <= 0.1) || (word[:probability] >= 0.9 && word[:spamProbability] <= 0.1))
					@emailU << word
		  end
		end
	end


	def probability
		#pSpam = 0.0  #probabilidad de spam
		#pNSpam = 0.0 #probabilidad de nospam
		#@emailU.each {|word| pSpam+=Math.log(word[:spamProbability]); pNSpam+=(Math.log(word[:probability])) }
		
		pSpam = 1.0  #probabilidad de spam
		pNSpam = 1.0 #probabilidad de nospam
		@emailU.each {|word| pSpam*=(word[:spamProbability]); pNSpam*=(word[:probability]) }
		
		p =  pSpam / (pSpam + pNSpam)
		 if(p >= 0.8)
	 	 @spam = true
	 	 else
	 	 @spam = false
	 	 end
		 @value = p
	end

	end
end
