function _init()
    palt(0, true)
    _c = {
        x = 64,
        y = 64,
        state="idle",
        on_horse = false,
        anim_i = {sf=236, nr=2, ns=2, nsx=2, spd=1, fl=false },
        anim_d = {sf=232, nr=2, ns=2, nsx=2, spd=3, fl=false },
        anim_u = {sf=228, nr=2, ns=2, nsx=2, spd=3, fl=false },
        anim_l = {sf=224, nr=2, ns=2, nsx=2, spd=3, fl=true },
        anim_r = {sf=224, nr=2, ns=2, nsx=2, spd=3, fl=false },
        anim_hi = {sf=202, nr=1, ns=2, nsx=2, spd=3, fl=false }
    }

    _h = {
        x = 40,
        y = 40,
        state="idle",
        anim_i = {sf=170, nr=2, ns=2, nsx=3, spd=1, fl=false },
        anim_l = {sf=138, nr=2, ns=2, nsx=3, spd=1, fl=false },
        anim_r = {sf=138, nr=2, ns=2, nsx=3, spd=1, fl=true },
    }

    _flagged_tiles = {}
end

function _update()
    if _c.on_horse then
        move(_h)
    else
        move(_c)
    end
end

function _draw()
    _c_x, _c_y = (_c.x-60), (_c.y-60)
    camera(_c_x,_c_y)
    cls(11)
    map()
    anim_char(_h)
    anim_char(_c)
    scan_area(_c)
    interact(_c, _h)
    _flagged_tiles={}
    debug()
end

function debug()
    print(_db, _c_x, _c_y+120, 1)
end

function animate_sprite(o, sf, nf, ns, nsx, sp, fl)
    if(not o.a_la) o.a_la = sf
    if(not o.a_ct) o.a_ct = 0
    if(not o.a_st) o.a_st = 0
    if(not o.fl) o.fl = false
    o.a_ct += 1
    if o.a_ct % (30/(sp)) == 0 then
        o.a_st += nsx
        if(o.a_st == (nf*nsx)) o.a_st = 0
    elseif o.a_la != sf then
        o.a_st = 0
    end

    o.a_fr = sf + o.a_st
    spr(o.a_fr, o.x, o.y, nsx, ns, fl)
    o.a_la = sf
end

function anim_char(c)
    if c.state=="idle" then
        if c.on_horse then
            local fl = false
            if (_h.state=="move_right") fl=true
            animate_sprite(c, c.anim_hi.sf, c.anim_hi.nr, c.anim_hi.ns, c.anim_hi.nsx, c.anim_hi.spd, fl)
            c.x=_h.x+3
            c.y=_h.y-5
        else
            animate_sprite(c, c.anim_i.sf, c.anim_i.nr, c.anim_i.ns, c.anim_i.nsx, c.anim_i.spd, c.anim_i.fl)
        end
    elseif c.state=="move_up" then
        animate_sprite(c, c.anim_u.sf, c.anim_u.nr, c.anim_u.ns, c.anim_u.nsx, c.anim_u.spd, c.anim_u.fl)
    elseif c.state=="move_down" then
        animate_sprite(c, c.anim_d.sf, c.anim_d.nr, c.anim_d.ns, c.anim_d.nsx, c.anim_d.spd, c.anim_d.fl)
    elseif c.state=="move_left" then
        animate_sprite(c, c.anim_l.sf, c.anim_l.nr, c.anim_l.ns, c.anim_l.nsx, c.anim_l.spd, c.anim_l.fl)
    elseif c.state=="move_right" then
        animate_sprite(c, c.anim_r.sf, c.anim_r.nr, c.anim_r.ns, c.anim_r.nsx, c.anim_r.spd, c.anim_r.fl)
    elseif c.on_horse then
        animate_sprite(c, c.anim_hi.sf, c.anim_hi.nr, c.anim_hi.ns, c.anim_hi.nsx, c.anim_hi.spd, c.anim_hi.fl)
        c.x=h.x+3
        c.y=h.y-5
    end
end

function move(c)
    if btn(⬆️) and not collide(c.x,c.y-1) then
        c.y-=1
        c.state="move_up"
    elseif btn(⬇️) and not collide(c.x,c.y+1) then
        c.y+=1
        c.state="move_down"
    elseif btn(⬅️) and not collide(c.x-1,c.y) then
        c.x-=1
        c.state="move_left"
    elseif btn(➡️) and not collide(c.x+1,c.y) then
        c.x+=1
        c.state="move_right"
    else
        c.state="idle"
    end
end

function collide(x,y,f)
    f = f or 0
    if fget(mget((x/8), (y/8)),f) then
        return true
    end
    return false
end

function scan_area(c)
    tile_x = flr(c.x/8)
    tile_y = flr(c.y/8)
    ut_co  = {x=tile_x, y=tile_y-1}
    ut_spr = mget(ut_co.x, ut_co.y)
    ut_flg = fget(ut_spr)
    dt_co  = {x=tile_x, y=tile_y+1}
    dt_spr = mget(dt_co.x, dt_co.y)
    dt_flg = fget(dt_spr)
    lt_co  = {x=tile_x-1, y=tile_y}
    lt_spr = mget(lt_co.x, lt_co.y)
    lt_flg = fget(lt_spr)
    rt_co  = {x=tile_x, y=tile_y}
    rt_spr = mget(ut_co.x, ut_co.y)
    rt_flg = fget(ut_spr)
    if ut_flg != 0 then
        add(_flagged_tiles, {t_co=ut_co, t_spr=ut_spr, t_flg=ut_flg})
    elseif dt_flag != 0 then
        add(_flagged_tiles, {t_co=dt_co, t_spr=dt_spr, t_flg=dt_flg})
    elseif lt_flag != 0 then
        add(_flagged_tiles, {t_co=lt_co, t_spr=lt_spr, t_flg=lt_flg})
    elseif rt_flag != 0 then
        add(_flagged_tiles, {t_co=rt_co, t_spr=rt_spr, t_flg=rt_flg})
    end
end

function interact(c, h)
    if btnp(❎) and c.state == "idle" then
        c.on_horse=true
        c.x=h.x+3
        c.y=h.y-5
    elseif btnp(❎) and c.on_horse then
        c.on_horse=false
    end
end

function fget2(pcf, f)
    return (pcf>>f)&1==1
end

