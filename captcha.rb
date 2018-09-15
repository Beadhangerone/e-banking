require './common'

class Captcha
  attr_reader :term1, :term2, :operator, :answer, :text

  def initialize
    @term1 = rand(10)
    @term2 = rand(10)
    @operator = rand(2).zero? ? -1 : +1
    @answer = @term1 + @term2 * @operator
    @text = "#{to_nr(@term1)} #{to_op(@operator)} #{to_nr(@term2)} => ".ljust(20)
  end

  def check(ans)
    res = ans.to_i == @answer
    res ? puts("Great! You're welcome!") : puts('Wrong! Try again please!')
    res
  end

  def to_nr(int)
    a = { 0 => 'zero', 1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four', 5 => 'five', 6 => 'six', 7 => 'seven', 8 => 'eight', 9 => 'nine' }
    a[int]
  end

  def to_op(operator)
    operator.to_s[0] == '-' ? 'minus' : 'plus'
  end

end
