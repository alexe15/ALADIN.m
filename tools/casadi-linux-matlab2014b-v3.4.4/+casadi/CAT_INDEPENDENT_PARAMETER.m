function v = CAT_INDEPENDENT_PARAMETER()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 128);
  end
  v = vInitialized;
end
