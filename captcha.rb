def to_nr(int)
  a = {0=>'zero', 1=>'one', 2=>'two', 3=>'three', 4=>'four', 5=>'five', 6=>'six', 7=>'seven', 8=>'eight',  9=>'nine'}
  return a[int]
end

def to_op(operator)
  operator.to_s[0] == '-' ? 'minus' : 'plus'
end

class Captcha
  attr_reader :term_1, :term_2, :operator, :answer, :text

  def initialize
    @term_1 = rand(10)
    @term_2 = rand(10)
    @operator = (rand(2) == 0) ? -1 : +1
    @answer = @term_1 + @term_2 * @operator
    @text = "#{to_nr(@term_1)} #{to_op(@operator)} #{to_nr(@term_2)} => ".ljust(20)
  end

  def check(ans)
    res = ans.to_i == @answer
    if res then puts("Great! You're welcome!") else puts('Wrong! Try again please!') end
    return res
  end

end
