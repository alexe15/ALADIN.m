function v = OP_LIFT()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 96);
  end
  v = vInitialized;
end
