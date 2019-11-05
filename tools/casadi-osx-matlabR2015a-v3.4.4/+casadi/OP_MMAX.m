function v = OP_MMAX()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 92);
  end
  v = vInitialized;
end
