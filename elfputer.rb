class Device
  attr_reader :reg

  def initialize
    @reg = []
  end

  def reset(*regs)
    @reg = regs
  end

  def addr(rega, regb, regc)
    @reg[regc] = @reg[rega] + @reg[regb]
  end

  def addi(rega, valb, regc)
    @reg[regc] = @reg[rega] + valb
  end

  def mulr(rega, regb, regc)
    @reg[regc] = @reg[rega] * @reg[regb]
  end

  def muli(rega, valb, regc)
    @reg[regc] = @reg[rega] * valb
  end

  def banr(rega, regb, regc)
    @reg[regc] = @reg[rega] & @reg[regb]
  end

  def bani(rega, valb, regc)
    @reg[regc] = @reg[rega] & valb
  end

  def borr(rega, regb, regc)
    @reg[regc] = @reg[rega] | @reg[regb]
  end

  def bori(rega, valb, regc)
    @reg[regc] = @reg[rega] | valb
  end

  def setr(rega, _, regc)
    @reg[regc] = @reg[rega].dup
  end

  def seti(vala, _, regc)
    @reg[regc] = vala
  end

  def gtir(vala, regb, regc)
    @reg[regc] = vala > @reg[regb] ? 1 : 0
  end

  def gtri(rega, valb, regc)
    @reg[regc] = @reg[rega] > valb ? 1 : 0
  end

  def gtrr(rega, regb, regc)
    @reg[regc] = @reg[rega] > @reg[regb] ? 1 : 0
  end

  def eqir(vala, regb, regc)
    @reg[regc] = vala == @reg[regb] ? 1 : 0
  end

  def eqri(rega, valb, regc)
    @reg[regc] = @reg[rega] == valb ? 1 : 0
  end

  def eqrr(rega, regb, regc)
    @reg[regc] = @reg[rega] == @reg[regb] ? 1 : 0
  end
end
