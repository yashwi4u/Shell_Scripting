file = open("environment","r")
content=file.read()
#print(content)
file.close()

str2=content[6:]
#print(str2)
str1=content[0:6]+"/usr/local/spark:"
content=str1+str2
#print(content)

file = open("/etc/environment","w")
file.write(content)
file.close()
