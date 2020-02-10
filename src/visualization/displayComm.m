function [ ] = displayComm( comm, innerAlg )
%DISPLAYCOMM 

disp(['  ------  communication D-' innerAlg])
disp(['local: ' num2str(comm.loc) ' floats        global: ' num2str(comm.glob) ' floats'])

end

