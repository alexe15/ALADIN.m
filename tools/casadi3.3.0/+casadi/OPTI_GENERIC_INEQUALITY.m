function v = OPTI_GENERIC_INEQUALITY()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 130);
  end
  v = vInitialized;
end
