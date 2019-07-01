function v = OP_COS()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 24);
  end
  v = vInitialized;
end
