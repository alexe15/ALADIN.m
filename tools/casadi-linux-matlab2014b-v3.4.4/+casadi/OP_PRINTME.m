function v = OP_PRINTME()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 96);
  end
  v = vInitialized;
end
