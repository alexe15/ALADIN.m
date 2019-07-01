function v = MNAME()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 0);
  end
  v = vInitialized;
end
