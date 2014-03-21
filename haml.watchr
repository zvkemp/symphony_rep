def compile_haml
  %x[haml index.haml index.html]
end

watch(".*\.haml$"){ compile_haml }
