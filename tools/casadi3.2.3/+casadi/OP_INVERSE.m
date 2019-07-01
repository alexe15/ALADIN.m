function v = OP_INVERSE()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 65);
  end
  v = vInitialized;
end
