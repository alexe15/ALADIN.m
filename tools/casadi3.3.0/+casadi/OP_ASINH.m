function v = OP_ASINH()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 50);
  end
  v = vInitialized;
end
