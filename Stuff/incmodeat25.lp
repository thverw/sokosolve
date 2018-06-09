#script (python) 

import clingo
import time

class GroundProgramObserver:
    #def begin_step(self):
     #   print("s")
    def output_atom(self, s, a):
        print(a.__str__() + ": " + s.__str__())
    def output_term(self, s, a):
        print(s)
        print(a)
    def weight_rule(self, s, a, c, d):
        print(s)
        print(a)
        print(c)
        print(d)
    def assume(self, literals):
        print("yo")
        print(literals)
    #def rule(self, c, h, b):
     #   print(c.__str__() + ", " + h.__str__() + ", " + b.__str__())

def get(val, default):
    return val if val != None else default

def main(prg):
    imin   = get(prg.get_const("imin"), clingo.Number(0))
    imax   = clingo.Number(100)#prg.get_const("imax")
    istop  = get(prg.get_const("istop"), clingo.String("SAT"))

    step, ret = 0, None
    myObs = GroundProgramObserver()
    prg.register_observer(myObs)
    while ((imax is None or step < imax.number) and
           (step == 0 or step < imin.number or ret == None or (
              (istop.string == "SAT"     and not ret.satisfiable) or
              (istop.string == "UNSAT"   and not ret.unsatisfiable) or 
              (istop.string == "UNKNOWN" and not ret.unknown)))):
		parts = []
		parts.append(("check", [step]))
		if step > 0:
		    prg.release_external(clingo.Function("query", [step-1]))
		    parts.append(("step", [step]))
		    prg.cleanup()
		else:
		    parts.append(("base", []))
		prg.ground(parts)
		prg.assign_external(clingo.Function("query", [step]), True)
		if(step < 55):
			ret, step = None, step+1
			print(parts)
		else:
			print(parts)
			ret, step = prg.solve(), step+1
		time.sleep(0.5)
			
#end.

#program check(t).
#external query(t).
