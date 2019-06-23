function v = OP_EINSTEIN()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 97);
  end
  v = vInitialized;
end
