--[[
Sliders functions:
Slider A: pitch adjustment
Slider B: Note
Slider C: Harmonics
Slider D: 2D spin speed (2.901) / static orientation
Slider E: 2D spin amount
Slider F: track volume
Slider G: Circle fade
Slider H: Mono fade
Slider I: Alternate fade
--]]

function bool_to_number(value)
  return value and 1 or 0
end

freq = 436.35 * slider_a / 2--/ 8 La 440Hz; période 1; 192kHz
--freq = 434 * slider_a / 2--/ 8 La 442Hz; période 1; 192kHz

frequencies = {freq,freq*.944,freq*.891,freq*.841,freq*.7937,freq*.749,freq*.707,
               freq*.6675,freq*.63,freq*.5945,freq*.5612,freq*.5298,freq/2}


--frequencies = {freq,freq*8/9,freq*64/81,freq*3/4,
--               freq*2/3,freq*16/27,freq*128/243,freq/2} --pythagorician scale


freq = frequencies[math.floor(slider_b)] -- notes
freq = freq/math.floor(slider_c) -- harmonics

crc_freq = freq/math.pi*4

--make square
l = math.abs(((step/freq)%2)-1)*2
r = math.abs(((step/freq+1/2)%2)-1)*2

--Re-centre
r = r-1
l = l-1


--make circle
cr = math.sin(4*step/crc_freq)
cl = math.cos(4*step/crc_freq)

--blend circle
r = (r*slider_g)+cr*(1-slider_g)
l = (l*slider_g)+cl*(1-slider_g)

--MONO
l = l*slider_h+r*(1-slider_h)

--SPIN
theta = (step/8^slider_d)*slider_e + slider_d*(1-slider_e)

sin_theta = math.sin(theta)
cos_theta = math.cos(theta)

r1 = r*cos_theta-l*sin_theta
l1 = r*sin_theta+l*cos_theta

r = r1
l = l1


--Alternate
state = state or false

if (state)
then 
    ar = 0
    al = l
    if (l < .008 and l > -.008)
    then state = not state
    end
else 
    al = 0
    ar = r
    if (r < .008 and r > -.008)
    then state = not state
    end
end

l = al * slider_i + l * (1-slider_i)
r = ar * slider_i + r * (1-slider_i)



--Volume
r = r * slider_f
l = l * slider_f




return {r, l}




