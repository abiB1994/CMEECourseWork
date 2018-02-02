# !/usr/bin/env python


__author__ = "Abigail Baines a.baines17@imperial.ac.uk"
__version__ = '0.0.1'


import cv2
import numpy as np
import matplotlib.image as mpimg
import matplotlib.pyplot as plt


img1 = cv2.imread("Testing/Abigail/UNADJUSTEDNONRAW_thumb_a54.jpg",0)          # queryImage
img2 = cv2.imread("Testing/Abigail/UNADJUSTEDNONRAW_thumb_a55.jpg",0) # trainImage

# # Initiate ORB detector
# orb = cv2.ORB_create()
# # find the keypoints and descriptors with ORB
# kp1new, des1new = orb.detectAndCompute(img1,None)
# kp2new, des2new = orb.detectAndCompute(img2,None)

# # create BFMatcher object
# bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)
# # Match descriptors.
# matches = bf.match(des1,des2)
# # Sort them in the order of their distance.
# matches = sorted(matches, key = lambda x:x.distance)
# # Draw first 10 matches.
# img3 = cv2.drawMatches(img1,kp1,img2,kp2,matches[:10], None, flags=2)
# plt.imshow(img3),plt.show()

# Initiate SIFT detector
sift = cv2.xfeatures2d.SIFT_create()
# find the keypoints and descriptors with SIFT
kp1, des1 = sift.detectAndCompute(img1,None)
kp2, des2 = sift.detectAndCompute(img2,None)

print(des1, "\n", des2)

# BFMatcher with default params
bf = cv2.BFMatcher()
matches = bf.knnMatch(des1,des2, k=2)
# Apply ratio test
good = []
for m,n in matches:
    if m.distance < 0.25*n.distance:
        good.append([m])


# cv.drawMatchesKnn expects list of lists as matches.

img3 = cv2.drawMatchesKnn(img1,kp1,img2,kp2,good[:8],  None, flags=2)
plt.imshow(img3),plt.show()

index1 = []
for point in kp1:
    temp1 = (point.pt)#, point.size, point.angle, point.response, point.octave, point.class_id
    index1.append(temp1)


index2 = []
for point in kp2:
    temp2 = (point.pt)#, point.size, point.angle, point.response, point.octave, point.class_id
    index2.append(temp2)

indexquery = []
indextrain = []
for point in good:
    tempquery = point[0].queryIdx
    temptrain = point[0].trainIdx 
    indexquery.append(tempquery)
    indextrain.append(temptrain)

working_list_q = []
for item in indexquery:
    if index1[item] != NameError:
        temp_find = index1[item]
    working_list_q.append(temp_find)


working_list_t = []
for item in indextrain:
    if index2[item] != NameError:
        temp_find = index2[item]
    working_list_t.append(temp_find)




# pts_src and pts_dst are numpy arrays of points
# in source and destination images. We need at least 
# 4 corresponding points.
h, status = cv2.findHomography(np.array(working_list_q[:8]), np.array(working_list_t[:8]))
 
# The calculated homography can be used to warp 
# the source image to destination. Size is the 
# size (width,height) of im_dst
 
im_dst = cv2.warpPerspective(img1, h, (img2.shape[1], img2.shape[0]))
cv2.imshow("Source Image", img1)
cv2.imshow("Destination Image", img2)
cv2.imshow("Warped Source Image", im_dst)



cv2.waitKey(0)

plt.imsave("Testing/Abigail/Warped Source Image", im_dst)