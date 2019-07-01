function v = CAT_DEPENDENT_CONSTANT()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 120);
  end
  v = vInitialized;
end
