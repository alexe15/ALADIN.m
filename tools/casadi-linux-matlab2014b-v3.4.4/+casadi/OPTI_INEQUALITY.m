function v = OPTI_INEQUALITY()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 133);
  end
  v = vInitialized;
end
