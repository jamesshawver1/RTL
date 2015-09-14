import sys,os,pickle

class Signal:
    direction = ""
    sig_type = ""
    name = ""
    packed_size = ""
    unpacked_size = ""
    net_name = ""
    def __str__(self):
      return self.direction + " " + self.sig_type + " " + self.packed_size + " " + self.name+ " " + self.unpacked_size
    def __init__(self,some_string):
      s = some_string.strip()
      if("/" in s):
        s = s.split("/")[0]
      if ( len(s) == 0) :
        return
      s = s.replace(",","")
      s = s.replace(";","")
      while (s.find("  ") >= 0):
        s = s.replace("  "," ") #removing duplicate spaces
      #moving size modifiers next to type
      s = s.replace("[ ","[")
      s = s.replace(" ]","]")
      #spliting up
      s = s.split(" ")
      
      #getting unpacked portions
      while("[" in s[-1]):
        self.unpacked_size= s[-1].strip + self.unpacked_size
        s.pop(-1)
      #name is always last
      self.name = s[-1].strip()
      s.pop(-1)

      if (s[0] == "input" or s[0] == "output" or s[0] == "inout"):
        self.direction = s[0].strip()
        s.pop(0)

      while(len(s)>1):
        if ("[" in s[-1]):
          self.packed_size= s[-1].strip() + self.packed_size
          s.pop(-1)
        else:
          raise Exception("unknown field in signal "+some_string+"\n("+str(s)+")\n")
      if (len(s) > 0):
        self.sig_type = s[0].strip()

class Module:
    parameters = ""
    signals = ""
    name = ""
    intermediate_nets = ""
    instance = ""
    def __init__(self,contents="False"):
      if(contents != "False"):
        self.name = parseModuleName(contents) 
        self.signals = createSignals(contents) 
        self.parameters = parseParameters(contents)
        self.instance = str(self)
        self.autoGenerateNets()
    def autoGenerateNets(self,othermodule=""):
      for i in self.signals:
        if(i.direction.strip() == "input" and othermodule!=""):
          for j in othermodule.signals:
            if (j.name[0:-2] == i.name[0:-2]):
              i.net_name=j.net_name
        elif(i.direction.strip() == "output"):
          wire_name = self.name+"_"+i.name.strip()
          if(wire_name[-2:-1]=="_"):
            wire_name = wire_name[0:-2]+"_s"
          else:
            wire_name = wire_name+"_s"
          i.net_name=wire_name
    def getIntermediateNets(self):
      string = ""
      for i in self.signals:
        string = string + "\n" +"wire "+i.sig_type+" "+i.packed_size+" "+i.net_name+" "+i.unpacked_size+"; "
      self.intermediate_nets = string
      return self.intermediate_nets
    def updateFromString(self,contents):
      self.name = parseModuleName(contents) 
      self.signals = createSignals(contents) 
      self.parameters = parseParameters(contents)
    def updateFromFile(self,afile):
      contents = retrieveFileContents(afile)
      self.name = parseModuleName(contents) 
      self.signals = createSignals(contents) 
      self.parameters = parseParameters(contents)
    def printSignals(self):
      for i in signals:
        print i
    def __str__(self):
      string = self.name + "\n" 
      if(self.parameters != ""):
        string = string + "    " + self.parameters.replace("parameter","").replace(" ","").replace("\n","").replace(")","))").replace(",","),.").replace("(","(.").replace("=","(") + "\n"
      string = string + self.name + "_inst\n    (\n"
      string = string + "    \n"
      self.getIntermediateNets()
      for i in self.signals:
        string = string + "\n    /*" +i.direction+" "+i.sig_type+" "+i.packed_size+" "+i.unpacked_size+"  */ ."+i.name+"("+i.net_name+"),"
      string = string.replace("input","input ")
      furthest = 0
      string = string[0:-1]
      string = string + "\n\n);\n\n"
      final_string = string.split("\n")
      for i in string.split("\n"):
        if(i.find("*/") > furthest):
          furthest = i.find("*/")
      final_string = ""
      for i in string.split("\n"):
        if ("*/" in i):
          rep = (" "*(furthest - i.find("*/")))+"*/"
          final_string = final_string + i.replace("*/",rep) +"\n"
        else:
          final_string = final_string + i +"\n"
      return final_string
    def writeModuleFile(self,f,instances=[],nets=""):
      f = open(f,"w")
      f.write("module "+self.name+"\n")
      if(self.parameters!=""):
        f.write("" + self.parameters + " \n")
      signals = "    "
      for i in self.signals:
        signals = signals + str(i) + ",\n    "
      f.write("( \n" + signals[0:signals.rfind(",")] +"\n\n);\n\n")
      f.write(nets)
      for i in instances:
        f.write(str(i))
      f.write("\n\n\nendmodule\n")
      f.close()

def parseThis(non_parsed,token1,token2):
  try:
    loc1=non_parsed.find(token1)+len(str(token1))
    loc2=non_parsed.find(token2)
    result = non_parsed[loc1:loc2]
    if (loc1 == -1 or loc2 == -1):
      return ""
    else:
      return result
  except:
    return ""

def retrieveFileContents(afile):
  contents = open(afile,"r").read()
  header = contents.split("module")[0]
  contents = contents.replace(header,"")
  return contents

def parseParameters(contents):
  param_loc = contents.find("parameter")
  if(param_loc < 0):
    return ""
  first_lparan = contents.find("(")
  first_rparan = contents.find(")")
  if(param_loc > first_lparan and param_loc < first_rparan):
    return contents[first_lparan-1:first_rparan+1]
  else:
    return ""

def createModule(contents):
    m = Module(contents)
    return Module(contents)

def createSignals(contents):
  parameters = parseParameters(contents)
  if(parameters == ""):
    signals= parseThis(contents,"(",");")
  else:
    signals= parseThis(contents.replace(parameters,""),"(",");")
  s = []
  for i in signals.split("\n"):
    b = Signal(i)
    if(len(str(b))>3):
      if(b.name.strip() != ""):
        s.append(b)
  return s

def parseSignals(contents):
  parameters = parseParameters(contents)
  if(parameters == ""):
    signals= parseThis(contents,"(",");")
  else:
    signals= parseThis(contents.replace(parameters,""),"(",");")
  return signals

def parseInstanceSignals(contents):
  instance_signals = parseSignals(contents)
  signal_names = parseSignalNames(contents)
  for s in signal_names:
    instance_signals = instance_signals.replace(s,"*/  ."+s+"("+s+")")
  instance_signals = instance_signals.replace("input","/*input")
  instance_signals = instance_signals.replace("output","/*output")
  instance_signals = instance_signals.replace("i)","s)")
  instance_signals = instance_signals.replace("o)","s)")
  return instance_signals

def parseSignalNames(contents):
  instance_signals = parseSignals(contents)
  signal_names = instance_signals.replace(" ","").replace("output","").replace("input","")
  signal_names = signal_names.split(",\n")
  snames = []
  for s in signal_names:
    if ("//" in s):
      s=str(s.split("/")[0])
      if(len(s) <=1):
        s=""
    if ( "]" in s):
      snames.append(s.split("]")[-1])
    elif (s!=""):
      snames.append(s)
  return snames

def parseModuleName(contents):
  param = parseParameters(contents)
  if param  == "":
    return parseThis(contents,"module","(").replace(" ","").replace("\n","")
  else:
    return parseThis(contents.replace(param,""),"module","(").replace(" ","").replace("\n","")


def parseInstanceDeclaration(contents):
  module_name = parseModuleName(contents)
  instance_signals = parseInstanceSignals(contents)
  return module_name+"\n"+parameters+"\n"+module_name+"_inst (\n"+instance_signals+"\n);\n\n"

def invertSignalDirection(contents):
  inv_signals = parseSignals(contents)
  inv_signals = inv_signals.replace("input","sad panda")
  inv_signals = inv_signals.replace("output","input")
  inv_signals = inv_signals.replace("sad panda","output")
  return inv_signals

def generateStim(module):
  stim = pickle.dumps(module)
  module = pickle.loads(stim)
  stim = pickle.loads(stim)

  signals = stim.signals
  to_keep = []
  for i in signals:
    if (i.direction=="output"):
      i.direction="input"
      if(i.name[-2:-1]=="_"):
        i.name=i.name[0:-2]+"_i"
      to_keep.append(i)
    elif (i.direction=="input"):
      i.direction="output"
      if(i.name[-2:-1]=="_"):
        i.name=i.name[0:-2]+"_o"
      to_keep.append(i)
  stim.signals=to_keep
  stim.name="Stimulus"
  stim.getIntermediateNets()
  return stim

def generateScoreBoard(module,s):
  expected = pickle.dumps(module)
  s = pickle.dumps(s)
  s = pickle.loads(s)
  module = pickle.loads(expected)
  expected = pickle.loads(expected)
  str(s)
  expected.name="ScoreBoard"
  expected_signals = []
  for i in module.signals:
    if (i.direction == "output"):
      i.name = module.name+"_"+i.name
      if(i.name[-2:-1] == "_"):
        i.name = i.name[0:-2]+"_i"
      i.direction ="input"
      expected_signals.append(i)
  for i in s.signals:
    if (i.direction == "output"):
      i.name = s.name+"_"+i.name
      if(i.name[-2:-1] == "_"):
        i.name = i.name[0:-2]+"_i"
      i.direction="input"
      expected_signals.append(i)
  expected.signals=expected_signals
  return expected

def generateTestBench(modules):
  expected = pickle.dumps(modules)
  modules = pickle.loads(expected)
  tb = modules[0]
  tb.signals=""
  tb.name = modules[0].name+"_tb"
  tb.signals = ""
  tb.intermediate_nets = ""
  tb.instance = ""
  return tb

def generateTestEnvironment(files):
  top_file = str(files)
  modules = []
  c = retrieveFileContents(top_file)
  c = createModule(c)
  module = c
  modules.append(module)

  try:
    os.mkdir("../tb/"+module.name)
  except:
    pass

  stim =generateStim(module)
  modules.append(stim)

  module.autoGenerateNets()
  stim.autoGenerateNets(module)

  module.autoGenerateNets(stim)

  expected = generateScoreBoard(module,stim)
  modules.append(expected)
  for i in modules:
    print i

  tb = generateTestBench(modules)
  print tb
  test_bench_file = "../tb/"+module.name+"/"+module.name+"_tb.sv"
  tb.writeModuleFile(test_bench_file,modules,stim.getIntermediateNets())

  stimulus_file= "../tb/"+module.name+"/"+stim.name+".sv"
  stim.writeModuleFile(stimulus_file)

  expect_file= "../tb/"+module.name+"/"+expected.name+".sv"
  expected.writeModuleFile(expect_file)

  f = open("test_"+tb.name+".f","w")
  f.write(top_file+"\n")
  f.write(test_bench_file+"\n")
  f.write(stimulus_file+"\n")
  f.write(expect_file+"\n")
  f.close()

if __name__ == "__main__":
  args = sys.argv
  args.pop(0)
  if(len(args) >0):
    for i in args:
      print i
      generateTestEnvironment(i)
  else:
    print "pass in files to this script. the first is the top module. the rest are instances to be put in the testbench."
