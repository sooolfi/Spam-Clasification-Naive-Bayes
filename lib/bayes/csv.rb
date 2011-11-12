module Bayes
  class Csv
    attr_accessor :file_path, :matrix, :trainingIndices, :testIndices
		attr_accessor :spam, :email

    def initialize(file_path)
      @file_path = file_path
			@spam = []
			@email = []
			@matrix = to_s
      @trainingIndices = Array.new
      @testIndices = Array.new
    end

    def to_s
      array = IO.readlines(@file_path)
      @matrix = to_string(array)
			res = "\r\n"
			@matrix.each do |linea|
			cont = linea.count
			linea[cont-1].delete!(res)
				if (linea[0]=="1")
				@email << linea[1..cont]
				else
				@spam << linea[1..cont]
				end
			end
		end

    def to_string(array)
      matrizAuxiliar = Array.new
      array.each { |a|  matrizAuxiliar << a.split(',') }
      matrizAuxiliar.each { |s| s.collect! { |x| x.to_s } }
			
    end

    # Crea los indices para lograr una partición aleatoria
    # de los entrenamientos y las pruebas

    def createIndices(porcentaje, cantidadParticiones)
      # creo un vector con los indices de mi tamaño de la matrix
      tamanio = @matrix.length

      # vector con los indices
      vectorAuxiliar = Array.new
      for i in 0..(tamanio-1)
        vectorAuxiliar << i
      end

      # hago la particion. Ej: 1000 => 800 / 200

      cantidadTraining = (porcentaje / 100.0 * tamanio).round
      cantidadTest = tamanio - cantidadTraining

      # recorro la cantidad de particiones y voy creando y agregando
      # a los respectivos arrays los índices

      cantidadParticiones.times do

        # shuffle! = mezcla el vector

        vectorAuxiliar.shuffle!
        aux1=Array.new
        aux2=Array.new

        # ingreso los indices

        for j in 0..(cantidadTraining - 1)
          aux1.push(vectorAuxiliar[j])
        end

        for k in cantidadTraining..(tamanio -1)
          aux2.push(vectorAuxiliar[k])
        end

        # ingresos en las variables del objeto el resultado.

        @trainingIndices.push(aux1)
        @testIndices.push(aux2)
      end
    end
  end
end
