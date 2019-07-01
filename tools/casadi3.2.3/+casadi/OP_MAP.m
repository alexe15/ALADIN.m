function v = OP_MAP()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 60);
  end
  v = vInitialized;
end
