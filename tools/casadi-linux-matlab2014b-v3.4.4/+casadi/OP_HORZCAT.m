function v = OP_HORZCAT()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 70);
  end
  v = vInitialized;
end
