function v = OP_NORM2()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 86);
  end
  v = vInitialized;
end
