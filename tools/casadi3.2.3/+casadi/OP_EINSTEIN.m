function v = OP_EINSTEIN()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 93);
  end
  v = vInitialized;
end
