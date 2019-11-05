function v = OPTI_DOUBLE_INEQUALITY()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 134);
  end
  v = vInitialized;
end
