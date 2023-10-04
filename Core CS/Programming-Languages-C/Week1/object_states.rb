class A
  def initialize f
    @foo = f
  end
  
  def m1
    @foo = 0
  end

  def m2 x 
    @foo += x
  end

  def foo
    @foo
  end
end
