class Module

  # Creates a class-variable attribute that can
  # be accessed both on an instance and class level.
  #
  # CREDIT: David Heinemeier Hansson
  def cattr( *syms )
    writers, readers = syms.flatten.partition{ |a| a.to_s =~ /=$/ }
    writers = writers.collect{ |e| e.to_s.chomp('=').to_sym }
    #readers.concat( writers ) # writers also get readers

    cattr_writer( *writers )
    cattr_reader( *readers )

    return readers + writers
  end

  # Creates a class-variable attr_reader that can
  # be accessed both on an instance and class level.
  #
  #   class CARExample
  #     @@a = 10
  #     cattr_reader :a
  #   end
  #
  #   CARExample.a           #=> 10
  #   CARExample.new.a       #=> 10
  #
  # CREDIT: David Heinemeier Hansson
  def cattr_reader( *syms )
    syms.flatten.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}
          @@#{sym}
        end

        def #{sym}
          @@#{sym}
        end
      EOS
    end
    return syms
  end

  # Creates a class-variable attr_writer that can
  # be accessed both on an instance and class level.
  #
  #   class CAWExample
  #     cattr_writer :a
  #     def self.a
  #       @@a
  #     end
  #   end
  #
  #   CAWExample.a = 10
  #   CAWExample.a            #=> 10
  #   CAWExample.new.a = 29
  #   CAWExample.a            #=> 29
  #
  # CREDIT: David Heinemeier Hansson
  def cattr_writer(*syms)
    syms.flatten.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}=(obj)
          @@#{sym} = obj
        end

        def #{sym}=(obj)
          @@#{sym}=(obj)
        end
      EOS
    end
    return syms
  end

  # Creates a class-variable attr_accessor that can
  # be accessed both on an instance and class level.
  #
  #   class CAAExample
  #     cattr_accessor :a
  #   end
  #
  #   CAAExample.a = 10
  #   CAAExample.a           #=> 10
  #   mc = CAAExample.new
  #   mc.a                   #=> 10
  #
  # CREDIT: David Heinemeier Hansson
  def cattr_accessor(*syms)
    cattr_reader(*syms) + cattr_writer(*syms)
  end

  # Creates a class-variable attribute that can
  # be accessed both on an instance and class level.
  #
  # NOTE: The #mattr methods may not be as useful for modules as the #cattr
  # methods are for classes, becuase class-level methods are not "inherited"
  # across the metaclass for included modules.
  #
  # CREDIT: David Heinemeier Hansson
  def mattr( *syms )
    writers, readers = syms.flatten.partition{ |a| a.to_s =~ /=$/ }
    writers = writers.collect{ |e| e.to_s.chomp('=').to_sym }
    readers.concat( writers ) # writers also get readers

    mattr_writer( *writers )
    mattr_reader( *readers )

    return readers + writers
  end

  # Creates a class-variable attr_reader that can
  # be accessed both on an instance and class level.
  #
  #   module MARExample
  #     @@a = 10
  #     mattr_reader :a
  #   end
  #
  #   MARExample.a           #=> 10
  #   MARExample.new.a       #=> 10
  #
  # CREDIT: David Heinemeier Hansson
  def mattr_reader( *syms )
    syms.flatten.each do |sym|
      module_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}
          @@#{sym}
        end

        def #{sym}
          @@#{sym}
        end
      EOS
    end
    return syms
  end

  # Creates a class-variable attr_writer that can
  # be accessed both on an instance and class level.
  #
  #   module MAWExample
  #     mattr_writer :a
  #     def self.a
  #       @@a
  #     end
  #   end
  #
  #   MAWExample.a = 10
  #   MAWExample.a            #=> 10
  #   MAWExample.new.a = 29
  #   MAWExample.a            #=> 29
  #
  # CREDIT: David Heinemeier Hansson
  def mattr_writer(*syms)
    syms.flatten.each do |sym|
      module_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}=(obj)
          @@#{sym} = obj
        end

        def #{sym}=(obj)
          @@#{sym}=(obj)
        end
      EOS
    end
    return syms
  end

  # Creates a class-variable attr_accessor that can
  # be accessed both on an instance and class level.
  #
  #   module MAAExample
  #     mattr_accessor :a
  #   end
  #
  #   MAAExample.a = 10
  #   MAAExample.a           #=> 10
  #   mc = MAAExample.new
  #   mc.a                   #=> 10
  #
  # CREDIT: David Heinemeier Hansson
  def mattr_accessor(*syms)
    mattr_reader(*syms) + mattr_writer(*syms)
  end

end
