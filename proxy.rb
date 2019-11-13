# A interface Subject declara operações comuns para as classes RealSubject e a
# Proxy. Desde que o cliente trabalhe com a RealSubject usando esta interface,
# você será capaz de passar o proxy ao invés da real subject.
class Subject
  # @abstract
  def request
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# A RealSubject contém alguma lógica principal dos negócios. Geralmente, RealSubjects são
# capazes de realizar algum trabalho útil que também pode ser muito lento ou sensível -
# por exemplo, corrigindo dados de entrada. Um Proxy pode resolver esses problemas sem nenhuma alteração
# para o código do RealSubject.
class RealSubject < Subject
  def request
    puts 'RealSubject: Handling request.'
  end
end

# O Proxy tem uma interface id~entica ao RealSubject.
class Proxy < Subject
  # @param [RealSubject] real_subject
  def initialize(real_subject)
    @real_subject = real_subject
  end

  # As aplicações mais comuns do padrão Proxy são lazy loading (aramzenamento lento), 
  # caching (armazendamento em cahce)
  # controlando o acesso, logging, etc. Um Proxy pode executar uma destas
  # coisas e então, dependendo do resultado, passa a exceução para o mesmo 
  # método em um objeto linkado ao RealSubject.
  def request
    return unless check_access

    @real_subject.request
    log_access
  end

  # @return [Boolean]
  def check_access
    puts 'Proxy: Checking access prior to firing a real request.'
    true
  end

  def log_access
    print 'Proxy: Logging the time of request.'
  end
end

# O código do cliente deve trabalhar como todos os objetos (ambos subjects e
# proxies) através da interface Subject, para suportar reais subjects e
# proxies. Na vida real, entretanto, clientes trabalham principalmente com os reais subjects deles
# diretamente. Neste caso, para implementar o padrão mais facilmente, você pode ampliar
# seu proxy da classe subject real .
def client_code(subject)
  # ...

  subject.request

  # ...
end

puts 'Client: Executing the client code with a real subject:'
real_subject = RealSubject.new
client_code(real_subject)

puts "\n"

puts 'Client: Executing the same client code with a proxy:'
proxy = Proxy.new(real_subject)
client_code(proxy)