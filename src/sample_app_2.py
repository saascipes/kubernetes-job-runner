import sys
import time


print("Running Sample App 2")
for i in range(5):
  print("Waiting 3 seconds...")
  sys.stdout.flush()
  time.sleep(3)
print("Sample App 2 Finished")
