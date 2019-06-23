function v = OP_MMAX()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 91);
  end
  v = vInitialized;
end
