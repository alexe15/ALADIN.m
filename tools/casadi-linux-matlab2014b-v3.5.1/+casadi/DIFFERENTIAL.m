function v = DIFFERENTIAL()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 121);
  end
  v = vInitialized;
end
