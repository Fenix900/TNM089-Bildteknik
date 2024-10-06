function toneMapImage = localToneMapping(HDR)
%Scale the range of the HDR into [0, 1]
HDRScaled = (HDR - min(HDR(:)))/ (max(HDR(:)) - min(HDR(:)));

toneMapImage = HDRScaled;
end

