function v = OP_ATANH()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 52);
  end
  v = vInitialized;
end
