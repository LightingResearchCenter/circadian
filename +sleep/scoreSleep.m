function sleep = scoreSleep(totalActivity,threshold)
%SCORESLEEP Score total activity counts as sleep(1) or wake(0)

sleep = totalActivity < threshold;

end

