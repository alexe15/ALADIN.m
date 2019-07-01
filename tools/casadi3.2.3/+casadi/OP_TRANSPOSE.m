function v = OP_TRANSPOSE()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 63);
  end
  v = vInitialized;
end
