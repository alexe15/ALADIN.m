function v = OP_TWICE()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 22);
  end
  v = vInitialized;
end
