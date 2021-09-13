from PIL import Image
from PIL import ImageEnhance
from PIL import ImageFilter
import cv2
import matplotlib.pyplot as plt 
a=input("Please enter the name of the picture you want to process, in the form of picture naming + format\n")
b=input("The name of the picture generated after processing, in the form of picture naming + format\n")
im1=Image.open(a)
c=eval(input("Please select the way to process the image:\nTo change the format (size, pixel, angle), please enter 1;\nFor image enhancement, please enter 2;\nFor filtering, please enter 3;\nFor synthesis, please enter 4;\nThe calculation is similar please enter 5；\n"))
if c==1:
    d=input("Please select the processing method: \na. Change the picture size; \nb. Change the picture pixel; \nc. Rotate the picture；\n")
    if d=="a":
        x=eval(input("x="))
        y=eval(input("y="))
        im=im1.resize((x,y),Image.ANTIALIAS)
        im.save(b)
        im.show()
    if d=="b":
        print("Please select the pixel format you want to change：\n1.mode=1;\n2.mode=L;\n3.mode=P;\n4.mode=RGB;\n5.mode=RGBA;\n6.mode=CMYK;\n7.mode=YCbCr;\n8.mode=I;\n9.mode=F;\n")
        e=input()
        if e=="1":
            im=im1.convert("1")
            im.save(b)
            im.show()
        if e=="2":
            im=im1.convert("L")
            im.save(b)
            im.show()
        if e=="3":
            im=im1.convert("P")
            im.save(b)
            im.show()
        if e=="4":
            im=im1.convert("RGB")
            im.save(b)
            im.show()
        if e=="5":
            im=im1.convert("RGBA")
            im.save(b)
            im.show()
        if e=="6":
            im=im1.convert("CMYK")
            im.save(b)
            im.show()
        if e=="7":
            im=im1.convert("YCbCr")
            im.save(b)
            im.show()
        if e=="8":
            im=im1.convert("I")
            im.save(b)
            im.show()
        if e=="9":
            im=im1.convert("F")
            im.save(b)
            im.show()
    if d=="c":
        f=eval(input())
        im=im1.rotate(f)
        im.save(b)
        im.show()
if c==2:
    g=input()
    h=eval(input())
    if g=="1":
        enhancer = ImageEnhance.Color(im1)
        enhancer.enhance(h).show("Color %f" % h)
        enhancer.save(b)
    if g=="2":
        enhancer = ImageEnhance.Brightness(im1)
        enhancer.enhance(h).show("Brightness %f" % h)
        enhancer.save(b)
    if g=="3":
        enhancer = ImageEnhance.Contrast(im1)
        enhancer.enhance(h).show("Contrast %f" % h)
        enhancer.save(b)
    if g=="4":
        enhancer = ImageEnhance.Sharpness(im1)
        enhancer.enhance(h).show("Sharpness %f" % h)
        enhancer.save(b)
if c==3:
    i=input()
    if i=="1":
        bluF = im1.filter(ImageFilter.BLUR)
        bluF.show()
        bluF.save(b)
    if i=="2":
        conF = im1.filter(ImageFilter.CONTOUR)
        conF.show()
        conF.save(b)
    if i=="3":
        edgeF = im1.filter(ImageFilter.FIND_EDGES)
        edgeF.show()
        edgeF.save(b)
if c==4:
    j=input()
    if j=="1":
        im2=Image.open(k)
        r,g,b = im1.split()
        print(b.mode)
        print(im1.mode,im1.size)
        print(im2.mode,im2.size)
        im = Image.composite(im1,im2,b)
        im.show()    
    if j=="2":
        def fun01(x):
            return x*0.3
        def fun02(y):
            return y*2.0
        im1_eval = Image.eval(im1, fun01)
        im2_eval = Image.eval(im1, fun02)
        im1_eval.show()
        im2_eval.show()
    if j=="3":
        im2=Image.open(k)
        r1,g1,b1 = im1.split()
        r2,g2,b2 = im2.split()
        print(r1.mode,r1.size,g1.mode,g1.size)
        print(r2.mode,r2.size,g2.mode,g2.size)
        new_im=[r1,g2,b2]
        print(len(new_im))
        im_merge = Image.merge("RGB",new_im)
        im_merge.show()
if c==5:
    def getss(list):
       avg=sum(list)/len(list)
       ss=0
       for l in list:
        ss+=(l-avg)*(l-avg)/len(list)   
        return ss
    def getdiff(img):
       Sidelength=30
       img=cv2.resize(img,(Sidelength,Sidelength),interpolation=cv2.INTER_CUBIC)
       gray=cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
       avglist=[]
       for i in range(Sidelength):
          avg=sum(gray[i])/len(gray[i])
          avglist.append(avg) 
       return avglist
    img1=cv2.imread(a)
    diff1=getdiff(img1)
    print('img1:',getss(diff1))
    img11=cv2.imread(k)
    diff11=getdiff(img11)
    print('img11:',getss(diff11))
    x=range(30)  
    plt.figure("avg")  
    plt.plot(x,diff1,marker="*",label="$walk01$") 
    plt.plot(x,diff11,marker="*",label="$walk03$") 
    plt.title("avg")
    plt.legend()
    plt.show()
    cv2.waitKey(0)
    cv2.destroyAllWindows()
