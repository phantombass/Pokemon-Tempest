#===
#RGSS Linker (Kernel)
#  Function that helps the load of extentions using RGSS Linker.
#---
#© 2015 - Nuri Yuri (塗 ゆり)
#===
if !mkxp?
  module Kernel
    unless @RGSS_Linker #>To avoid the RGSS Reset problem

    @RGSS_Linker = {:core => Win32API.new("RGSS Linker.dll","RGSSLinker_Initialize","p","i")}
    Win32API.new("kernel32","GetPrivateProfileString","ppppip","i").call("Game","Library",0,lib_name = "\x00"*32,32,".//Game.ini")
    raise LoadError, "Failed to load RGSS Linker." unless(@RGSS_Linker[:core].call(lib_name)==1)
    lib_name = nil
    module_function
    #===
    #>Kernel.load_module
    #  Helps to load a RGSS extension
    #---
    #I : module_filename : String : Name of the file which contains the extension
    #    module_function : String : Name of the function that will load the extension
    #===
    def load_module(module_filename, module_function)
      return if @RGSS_Linker[module_filename]
      mod = @RGSS_Linker[module_filename] = Win32API.new(module_filename, module_function, "", "")
      mod.call
    end

    end #>unless @RGSS_Linker
  end
end
