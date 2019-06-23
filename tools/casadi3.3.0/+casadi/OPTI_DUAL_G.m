function v = OPTI_DUAL_G()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 138);
  end
  v = vInitialized;
end
