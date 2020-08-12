do
  -- create websock protocol and its fields
  local pwr = Proto("pwr","Proview WebSocket Protocol")
  local PROTOCOL_HEADER = Proto("pwr.header", "Protocol Header")
  local PAYLOAD = Proto("pwr.payload", "Payload")

  local SET_OBJECT_INFO = Proto("pwr.setobjectinfo", "Set Object Info")
  local GET_OBJECT_INFO = Proto("pwr.getobjectinfo", "Get Object Info")
  local TOGGLE_OBJECT_INFO = Proto("pwr.toggleobjectinfo", "Toggle Object Info")
  local REF_OBJECT_INFO = Proto("pwr.refobjectinfo", "Ref Object Info")
  local GET_OBJECT_REF_INFO_ALL = Proto("pwr.getobjectrefinfoall", "Get All Ref Objects")

  local GET_OBJECT = Proto("pwr.getobject", "Get Object")

  local MH_SYNC = Proto("pwr.mhsync", "MH Sync")
  local MH_ACK = Proto("pwr.mhack", "MH Acknowledge")

  local CHECK_USER = Proto("pwr.checkuser", "Check User")
  local GET_ALL_XTT_CHILDREN = Proto("pwr.getallxttchildren", "Get All Xtt Children")
  local GET_OPWIND_MENU = Proto("pwr.getopwindmenu", "Get Operator Window Menu")
  local GET_ALL_CLASS_ATTRIBUTES = Proto("pwr.getallclassattributes", "Get All Class Attributes")
  local CRR_SIGNAL = Proto("pwr.crrsignal", "CRR Signal")
  local GET_MESSAGE = Proto("pwr.getmsg", "Get Message Text")

  local messageTypes = {
    [1] = "setObjectInfoBool", --No res payload
    [2] = "setObjectInfoFloat", --No res payload
    [3] = "setObjectInfoInt", --No res payload
    [4] = "setObjectInfoString", --No res payload
    [5] = "getObjectInfoBool",
    [6] = "getObjectInfoFloat",
    [7] = "getObjectInfoInt",
    [9] = "toggleObjectInfo", --No res payload
    [10] = "refObjectInfo", --No res payload
    [15] = "unrefObjectInfo", --No res payload
    [25] = "getObjectRefInfoAll",
    [29] = "checkUser",
    [36] = "getAllClassAttributes",
    [39] = "getAllXttChildren",
    [42] = "crrSignal",
    [50] = "getMsg",
    [57] = "getObjectInfoFloatArray",
    [63] = "getObject",
    [64] = "getOpWindMenu",
    [65] = "getObjectFromName",
    [66] = "mhSync",
    [67] = "mhAck", --No res payload
    [68] = "getObjectFromARef"
  }

  -- setObjectInfo...
  -- getObjectInfo...
  -- toggleObjectInfo
  -- unrefObjectInfo
  -- crrSignal
  -- getMsg
  -- getObjectInfoFloatArray
  -- getObjectFromName
  -- mhAck
  -- getObjectFromARef

  local ph = PROTOCOL_HEADER.fields
  ph.opcode = ProtoField.uint8("pwr.opcode", "OpCode", base.DEC)
  ph.messageID = ProtoField.uint32("pwr.messageID", "Message ID", base.DEC)
  ph.sts = ProtoField.uint32("pwr.sts", "Status", base.DEC)

  local pl = PAYLOAD.fields
  pl.data = ProtoField.bytes("pwr.data", "Data")

  local soi = SET_OBJECT_INFO.fields
  soi.attrNameLen = ProtoField.uint16("pwr.setobjectinfo.attrnamelen", "Attr Name Length", base.DEC)
  soi.attrName = ProtoField.string("pwr.setobjectinfo.attrname", "Attr Name")
  soi.boolData = ProtoField.bool("pwr.setobjectinfo.booldata", "Boolean Data")
  soi.floatData = ProtoField.float("pwr.setobjectinfo.floatdata", "Float Data")
  soi.intData = ProtoField.float("pwr.setobjectinfo.intdata", "Integer Data")
  soi.strDataLen = ProtoField.uint16("pwr.setobjectinfo.strdatalen", "String Data Length", base.DEC)
  soi.strData = ProtoField.float("pwr.setobjectinfo.strdata", "String Data")

  local goi = GET_OBJECT_INFO.fields
  goi.arrLen = ProtoField.uint32("pwr.getobjectinfo.arrlen", "Array Length", base.DEC)
  goi.attrNameLen = ProtoField.uint16("pwr.getobjectinfo.attrnamelen", "Attr Name Length", base.DEC)
  goi.attrName = ProtoField.string("pwr.getobjectinfo.attrname", "Attr Name")
  goi.boolData = ProtoField.bool("pwr.getobjectinfo.booldata", "Boolean Data")
  goi.floatData = ProtoField.float("pwr.getobjectinfo.floatdata", "Float Data")
  goi.intData = ProtoField.float("pwr.getobjectinfo.intdata", "Integer Data")
  goi.strDataLen = ProtoField.uint16("pwr.getobjectinfo.strdatalen", "String Data Length", base.DEC)
  goi.strData = ProtoField.float("pwr.getobjectinfo.strdata", "String Data")

  local toi = TOGGLE_OBJECT_INFO.fields
  toi.attrNameLen = ProtoField.uint16("pwr.toggleobjectinfo.attrnamelen", "Attr Name Length", base.DEC)
  toi.attrName = ProtoField.string("pwr.toggleobjectinfo.attrname", "Attr Name")

  local roi = REF_OBJECT_INFO.fields
  roi.subid = ProtoField.uint32("pwr.refobjectinfo.subid", "Subscription ID", base.DEC)
  roi.elements = ProtoField.uint32("pwr.refobjectinfo.elements", "Elements", base.DEC)
  roi.nameLen = ProtoField.uint16("pwr.refobjectinfo.namelen", "Name Length", base.DEC)
  roi.name = ProtoField.string("pwr.refobjectinfo.name", "Name")

  local goria = GET_OBJECT_REF_INFO_ALL.fields
  goria.length = ProtoField.uint32("pwr.getobjectrefinfoall.length", "Array Length")
  goria.a = ProtoField.new("Array", "pwr.getobjectrefinfoall.a", ftypes.NONE)
  goria.subIdx = ProtoField.uint32("pwr.getobjectrefinfoall.subidx", "Variable Subscription Index")
  goria.dataSize = ProtoField.uint32("pwr.getobjectrefinfoall.datasize", "Data Size")
  goria.data = ProtoField.bytes("pwr.getobjectrefinfoall.data", "Data")



  local go = GET_OBJECT.fields
  go.opcode = ProtoField.uint16("pwr.getobject.opcode", "OpCode", base.DEC)
  go.vid = ProtoField.uint32("pwr.getobject.vid", "VID", base.DEC)
  go.oix = ProtoField.uint32("pwr.getobject.oix", "OIX", base.DEC)
  go.offset = ProtoField.uint32("pwr.getobject.offset", "Offset", base.DEC)
  go.body = ProtoField.uint32("pwr.getobject.body", "Body", base.DEC)
  go.size = ProtoField.uint32("pwr.getobject.size", "Size", base.DEC)
  go.flags = ProtoField.uint32("pwr.getobject.flags", "Flags")
  go.cid = ProtoField.uint32("pwr.getobject.cid", "Class ID", base.DEC)
  go.hasChildren = ProtoField.uint8("pwr.getobject.haschildren", "Has Children", base.DEC)
  go.nameLen = ProtoField.uint16("pwr.getobject.namelen", "Name Length", base.DEC)
  go.name = ProtoField.string("pwr.getobject.name", "Name")
  go.fullnameLen = ProtoField.uint16("pwr.getobject.fullnamelen", "Full Name Length", base.DEC)
  go.fullname = ProtoField.string("pwr.getobject.fullname", "Full Name")
  go.classnameLen = ProtoField.uint16("pwr.getobject.classnamelen", "Class Name Length", base.DEC)
  go.classname = ProtoField.string("pwr.getobject.classname", "Class Name")
  go.descLen = ProtoField.uint16("pwr.getobject.desclen", "Description Length", base.DEC)
  go.desc = ProtoField.string("pwr.getobject.desc", "Description")
  go.paramLen = ProtoField.uint16("pwr.getobject.paramlen", "Parameter Length", base.DEC)
  go.param = ProtoField.string("pwr.getobject.param", "Parameter")



  local mhsync = MH_SYNC.fields
  mhsync.sync = ProtoField.uint32("pwr.mhsync.sync", "Sync ID", base.DEC)
  mhsync.arrLen = ProtoField.uint32("pwr.mhsync.arrlen", "Array Length", base.DEC)
  mhsync.events = ProtoField.new("Event", "pwr.mhsync.events", ftypes.NONE)
  mhsync.eventTimeLen = ProtoField.uint16("pwr.mhsync.events.timelen", "Time Length", base.DEC)
  mhsync.eventTime = ProtoField.string("pwr.mhsync.events.time", "Time")
  mhsync.eventTextLen = ProtoField.uint16("pwr.mhsync.events.textlen", "Text Length", base.DEC)
  mhsync.eventText = ProtoField.string("pwr.mhsync.events.text", "Text")
  mhsync.eventNameLen = ProtoField.uint16("pwr.mhsync.events.namelen", "Name Length", base.DEC)
  mhsync.eventName = ProtoField.string("pwr.mhsync.events.name", "Name")
  mhsync.eventFlags = ProtoField.uint32("pwr.mhsync.events.flags", "Flags")
  mhsync.eventStatus = ProtoField.uint32("pwr.mhsync.events.status", "Status", base.DEC)
  mhsync.eventPrio = ProtoField.uint32("pwr.mhsync.events.prio", "Priority", base.DEC)
  mhsync.eventID = ProtoField.new("Event ID", "pwr.mhsync.events.id", ftypes.NONE)
  mhsync.eventIDNix = ProtoField.uint32("pwr.mhsync.events.id.nix", "NIX", base.DEC)
  mhsync.eventIDIdx = ProtoField.uint32("pwr.mhsync.events.id.idx", "Index", base.DEC)
  mhsync.eventIDbirthTimeLen = ProtoField.uint16("pwr.mhsync.events.id.btimeLen", "Birth Time Length", base.DEC)
  mhsync.eventIDbirthTime = ProtoField.string("pwr.mhsync.events.id.btime", "Birth Time")
  mhsync.eventTargetID = ProtoField.new("Event Target ID", "pwr.mhsync.events.targetid", ftypes.NONE)
  mhsync.eventTargetIDNix = ProtoField.uint32("pwr.mhsync.events.targetid.nix", "NIX", base.DEC)
  mhsync.eventTargetIDIdx = ProtoField.uint32("pwr.mhsync.events.targetid.idx", "Index", base.DEC)
  mhsync.eventTargetIDbirthTimeLen = ProtoField.uint16("pwr.mhsync.events.targetid.btimeLen", "Birth Time Length", base.DEC)
  mhsync.eventTargetIDbirthTime = ProtoField.string("pwr.mhsync.events.targetid.btime", "Birth Time")
  mhsync.eventType = ProtoField.uint32("pwr.mhsync.events.type", "Type")
  mhsync.eventObject = ProtoField.new("Event Object", "pwr.mhsync.events.object", ftypes.NONE)
  mhsync.eventObjectVid = ProtoField.uint32("pwr.mhsync.events.object.vid", "VID", base.DEC)
  mhsync.eventObjectOix = ProtoField.uint32("pwr.mhsync.events.object.oix", "OIX", base.DEC)
  mhsync.eventObjectOffset = ProtoField.uint32("pwr.mhsync.events.object.offset", "Offset", base.DEC)
  mhsync.eventObjectBody = ProtoField.uint32("pwr.mhsync.events.object.body", "Body")
  mhsync.eventObjectSize = ProtoField.uint32("pwr.mhsync.events.object.size", "Size", base.DEC)
  mhsync.eventObjectFlags = ProtoField.uint32("pwr.mhsync.events.object.flags", "Flags")
  mhsync.eventSupObject = ProtoField.new("Event Object", "pwr.mhsync.events.supobject", ftypes.NONE)
  mhsync.eventSupObjectVid = ProtoField.uint32("pwr.mhsync.events.supobject.vid", "VID", base.DEC)
  mhsync.eventSupObjectOix = ProtoField.uint32("pwr.mhsync.events.supobject.oix", "OIX", base.DEC)
  mhsync.eventSupObjectOffset = ProtoField.uint32("pwr.mhsync.events.supobject.offset", "Offset", base.DEC)
  mhsync.eventSupObjectBody = ProtoField.uint32("pwr.mhsync.events.supobject.body", "Body")
  mhsync.eventSupObjectSize = ProtoField.uint32("pwr.mhsync.events.supobject.size", "Size", base.DEC)
  mhsync.eventSupObjectFlags = ProtoField.uint32("pwr.mhsync.events.supobject.flags", "Flags")
  mhsync.eventMoreTextLen = ProtoField.uint16("pwr.mhsync.events.moretextlen", "More Text Length", base.DEC)
  mhsync.eventMoreText = ProtoField.string("pwr.mhsync.events.moretext", "More Text")
  mhsync.eventSyncIdx = ProtoField.uint32("pwt.mhsync.events.syncidx", "Sync Index", base.DEC)


  local mhack = MH_ACK.fields
  mhack.nix = ProtoField.uint32("pwr.mhack.nix", "NIX", base.DEC)
  mhack.idx = ProtoField.uint32("pwr.mhack.idx", "Index", base.DEC)
  mhack.birthTimeLen = ProtoField.uint16("pwr.mhack.btimeLen", "Birth Time Length", base.DEC)
  mhack.birthTime = ProtoField.string("pwr.mhack.btime", "Birth Time")



  local cu = CHECK_USER.fields
  cu.usernameLen = ProtoField.uint16("pwr.checkuser.usernameLen", "Username Length", base.DEC)
  cu.username = ProtoField.string("pwr.checkuser.username", "Username")
  cu.passwordLen = ProtoField.uint16("pwr.checkuser.passwordLen", "Password Length", base.DEC)
  cu.password = ProtoField.string("pwr.checkuser.password", "Password")
  cu.priv = ProtoField.uint32("pwr.checkuser.priv", "Privilege", base.DEC)

  local gaxc = GET_ALL_XTT_CHILDREN.fields
  gaxc.vid = ProtoField.uint32("pwr.getallxttchildren.vid", "VID", base.DEC)
  gaxc.oix = ProtoField.uint32("pwr.getallxttchildren.oix", "OIX", base.DEC)
  gaxc.arrLen = ProtoField.uint16("pwr.getallxttchildren.arrlen", "Array Length", base.DEC)
  gaxc.children = ProtoField.new("Child", "pwr.getallxttchildren.children", ftypes.NONE)
  gaxc.childVid = ProtoField.uint32("pwr.getallxttchildren.children.vid", "VID", base.DEC)
  gaxc.childOix = ProtoField.uint32("pwr.getallxttchildren.children.oix", "OIX", base.DEC)
  gaxc.childCid = ProtoField.uint32("pwr.getallxttchildren.children.cid", "Class ID", base.DEC)
  gaxc.childHasChildren = ProtoField.uint8("pwr.getallxttchildren.children.hasChildren", "Has Children")
  gaxc.childNameLen = ProtoField.uint16("pwr.getallxttchildren.children.namelen", "Name Length", base.DEC)
  gaxc.childName = ProtoField.string("pwr.getallxttchildren.children.name", "Name")
  gaxc.childDescLen = ProtoField.uint16("pwr.getallxttchildren.children.descLen", "Description Length", base.DEC)
  gaxc.childDesc = ProtoField.string("pwr.getallxttchildren.children.desc", "Description")
  gaxc.childClassnameLen = ProtoField.uint16("pwr.getallxttchildren.children.classnamelen", "Classname Length", base.DEC)
  gaxc.childClassname = ProtoField.string("pwr.getallxttchildren.children.classname", "Classname")

  local gom = GET_OPWIND_MENU.fields
  gom.placeLen = ProtoField.uint16("pwr.getopwindmenu.placelen", "Operator Place Length", base.DEC)
  gom.place = ProtoField.string("pwr.getopwindmenu.place", "Operator Place")
  gom.titleLen = ProtoField.uint16("pwr.getopwindmenu.titlelen", "Title Length", base.DEC)
  gom.title = ProtoField.string("pwr.getopwindmenu.title", "Title")
  gom.textLen = ProtoField.uint16("pwr.getopwindmenu.textlen", "Text Length", base.DEC)
  gom.text = ProtoField.string("pwr.getopwindmenu.text", "Text")
  gom.enableLang = ProtoField.uint8("pwr.getopwindmenu.enablelang", "Enable Language", base.DEC)
  gom.enableLogin = ProtoField.uint8("pwr.getopwindmenu.enablelogin", "Enable Login", base.DEC)
  gom.enableAlarmList = ProtoField.uint8("pwr.getopwindmenu.enablealarmlist", "Enable Alarm List", base.DEC)
  gom.enableEventLog = ProtoField.uint8("pwr.getopwindmenu.enableeventlog", "Enable Event Log", base.DEC)
  gom.enableNavigator = ProtoField.uint8("pwr.getopwindmenu.enablenavigator", "Enable Navigator", base.DEC)
  gom.disableHelp = ProtoField.uint8("pwr.getopwindmenu.disablehelp", "Disable Help", base.DEC)
  gom.disableProview = ProtoField.uint8("pwr.getopwindmenu.disableproview", "Disable Proview", base.DEC)
  gom.lang = ProtoField.uint32("pwr.getopwindmenu.lang", "Language", base.DEC)
  gom.cdhrClassId = ProtoField.uint32("pwr.getopwindmenu.disableproview", "CDHR Class ID", base.DEC)
  gom.arrLen = ProtoField.uint16("pwr.getopwindmenu.arrlen", "Array Length", base.DEC)
  gom.children = ProtoField.new("Child", "pwr.getopwindmenu.children", ftypes.NONE)
  gom.childTextLen = ProtoField.uint16("pwr.getopwindmenu.children.textlen", "Text Length", base.DEC)
  gom.childText = ProtoField.string("pwr.getopwindmenu.children.text", "Text")
  gom.childNameLen = ProtoField.uint16("pwr.getopwindmenu.children.namelen", "Name Length", base.DEC)
  gom.childName = ProtoField.string("pwr.getopwindmenu.children.name", "Name")
  gom.childUrlLen = ProtoField.uint16("pwr.getopwindmenu.children.urllen", "URL Length", base.DEC)
  gom.childUrl = ProtoField.string("pwr.getopwindmenu.children.url", "URL")

  local gaca = GET_ALL_CLASS_ATTRIBUTES.fields
  gaca.cid = ProtoField.uint32("pwr.getallclassattributes.cid", "Class ID", base.DEC)
  gaca.vid = ProtoField.uint32("pwr.getallclassattributes.vid", "VID", base.DEC)
  gaca.oix = ProtoField.uint32("pwr.getallclassattributes.oix", "OIX", base.DEC)
  gaca.arrLen = ProtoField.uint16("pwr.getallclassattributes.arrlen", "Array Length", base.DEC)
  gaca.children = ProtoField.new("Child", "pwr.getallclassattributes.children", ftypes.NONE)
  gaca.childType = ProtoField.uint32("pwr.getallclassattributes.children.type", "Type")
  gaca.childFlags = ProtoField.uint32("pwr.getallclassattributes.children.flags", "Flags")
  gaca.childSize = ProtoField.uint16("pwr.getallclassattributes.children.size", "Size")
  gaca.childElements = ProtoField.uint16("pwr.getallclassattributes.children.elements", "Elements")
  gaca.childNameLen = ProtoField.uint16("pwr.getallclassattributes.children.namelen", "Name Length", base.DEC)
  gaca.childName = ProtoField.string("pwr.getallclassattributes.children.name", "Name")
  gaca.childClassnameLen = ProtoField.uint16("pwr.getallclassattributes.children.classnamelen", "Classname Length", base.DEC)
  gaca.childClassname = ProtoField.string("pwr.getallclassattributes.children.classname", "Classname")

  local crr = CRR_SIGNAL.fields
  crr.vid = ProtoField.uint32("pwr.crrsignal.vid", "VID", base.DEC)
  crr.oix = ProtoField.uint32("pwr.crrsignal.oix", "OIX", base.DEC)
  crr.arrayLength = ProtoField.uint16("pwr.crrsignal.arrlen", "Array Length", base.DEC)
  crr.children = ProtoField.new("Child", "pwr.crrsignal.children", ftypes.NONE)
  crr.childType = ProtoField.uint16("pwr.crrsignal.children.type", "Type", base.DEC)
  crr.childVid = ProtoField.uint32("pwr.crrsignal.children.vid", "VID", base.DEC)
  crr.childOix = ProtoField.uint32("pwr.crrsignal.children.oix", "OIX", base.DEC)
  crr.childNameLen = ProtoField.uint16("pwr.crrsignal.children.namelen", "Name Length", base.DEC)
  crr.childName = ProtoField.string("pwr.crrsignal.children.name", "Name")
  crr.childClassnameLen = ProtoField.uint16("pwr.crrsignal.children.classnamelen", "Classname Length", base.DEC)
  crr.childClassname = ProtoField.string("pwr.crrsignal.children.classname", "Classname")

  local gmt = GET_MESSAGE.fields
  gmt.msgid = ProtoField.uint32("pwr.getmsg.msgid", "Message ID", base.DEC)
  gmt.msgTextLen = ProtoField.uint16("pwr.getmsg.msgtextlen", "Message Text Length", base.DEC)
  gmt.msgText = ProtoField.string("pwr.getmsg.msgtext", "Message Text")

  function setObjectInfoBoolReq(buf, subtree)
    local offset = 0
    local payload = subtree:add(SET_OBJECT_INFO, buf())

    payload:add(soi.boolData, buf(offset, 1))
    offset = offset + 1

    local attrNameLen = buf(offset, 4)
    payload:add(soi.attrNameLen, attrNameLen)
    offset = offset + 4
    payload:add(soi.attrName, buf(offset, attrNameLen:uint()))
  end

  function setObjectInfoFloatReq(buf, subtree)
    local offset = 0
    local payload = subtree:add(SET_OBJECT_INFO, buf())

    payload:add(soi.floatData, buf(offset, 4))
    offset = offset + 4

    local attrNameLen = buf(offset, 4)
    payload:add(soi.attrNameLen, attrNameLen)
    offset = offset + 4
    payload:add(soi.attrName, buf(offset, attrNameLen:uint()))
  end

  function setObjectInfoIntReq(buf, subtree)
    local offset = 0
    local payload = subtree:add(SET_OBJECT_INFO, buf())

    payload:add(soi.intData, buf(offset, 4))
    offset = offset + 4

    local attrNameLen = buf(offset, 4)
    payload:add(soi.attrNameLen, attrNameLen)
    offset = offset + 4
    payload:add(soi.attrName, buf(offset, attrNameLen:uint()))
  end

  function setObjectInfoStrReq(buf, subtree)
    local offset = 0
    local payload = subtree:add(SET_OBJECT_INFO, buf())

    local strDataLen = buf(offset, 4):uint()
    payload:add(soi.strDataLen, buf(offset, 4))
    offset = offset + 4
    if strDataLen > 0 then
      payload:add(soi.strData, buf(offset, strDataLen))
      offset = offset + strDataLen
    end

    local attrNameLen = buf(offset, 4)
    payload:add(soi.attrNameLen, attrNameLen)
    offset = offset + 4
    payload:add(soi.attrName, buf(offset, attrNameLen:uint()))
  end

  -- Same for all four types (bool, float, int, str)
  function getObjectInfoReq(buf, subtree)
    local offset = 0
    local payload = subtree:add(GET_OBJECT_INFO, buf())

    local attrNameLen = buf(offset, 4)
    payload:add(goi.attrNameLen, attrNameLen)
    offset = offset + 4
    payload:add(goi.attrName, buf(offset, attrNameLen:uint()))
  end

  function getObjectInfoBoolRes(buf, subtree)
    local payload = subtree:add(GET_OBJECT_INFO, buf())
    payload:add(goi.boolData, buf(0, 1))
  end

  function getObjectInfoFloatRes(buf, subtree)
    local payload = subtree:add(GET_OBJECT_INFO, buf())
    payload:add(goi.floatData, buf(0, 4))
  end

  function getObjectInfoIntRes(buf, subtree)
    local payload = subtree:add(GET_OBJECT_INFO, buf())
    payload:add(goi.intData, buf(0, 4))
  end

  -- Same for all types (float, int)
  function getObjectInfoArrayReq(buf, subtree)
    local offset = 0
    local payload = subtree:add(GET_OBJECT_INFO, buf())

    payload:add(goi.arrLen, buf(offset, 4))
    offset = offset + 4

    local attrNameLen = buf(offset, 4)
    payload:add(goi.attrNameLen, attrNameLen)
    offset = offset + 4
    payload:add(goi.attrName, buf(offset, attrNameLen:uint()))
  end

  function getObjectInfoFloatArrayRes(buf, subtree)
    local payload = subtree:add(GET_OBJECT_INFO, buf())
    local offset = 0
    local arrLen = buf(offset, 4):uint()
    payload:add(goi.arrLen, buf(offset, 4))
    offset = offset + 4

    for i=1,arrLen do
      payload:add(goi.floatData, buf(offset, 4))
      offset = offset + 4
    end
  end

  function toggleObjectInfoReq(buf, subtree)
    local payload = subtree:add(TOGGLE_OBJECT_INFO, buf())

    local offset = 0
    local attrNameLen = buf(offset, 4)
    payload:add(toi.attrNameLen, attrNameLen)
    offset = offset + 4
    payload:add(toi.attrName, buf(offset, attrNameLen:uint()))
  end

  function refObjectInfoReq(buf, subtree)
    local payload = subtree:add(REF_OBJECT_INFO, buf())
    local offset = 0

    payload:add(roi.subid, buf(offset, 4))
    offset = offset + 4
    payload:add(roi.elements, buf(offset, 4))
    offset = offset + 4

    local nameLen = buf(offset, 4)
    payload:add(roi.nameLen, nameLen)
    offset = offset + 4
    payload:add(roi.name, buf(offset, nameLen:uint()))
  end

  function unrefObjectInfoReq(buf, subtree)
    local payload = subtree:add(REF_OBJECT_INFO, buf())
    payload:add(roi.subid, buf(0, 4))
  end

  function getObjectRefInfoAllRes(buf, subtree) --TODO
    local offset = 0
    local payload = subtree:add(GET_OBJECT_REF_INFO_ALL, buf())

    local length = buf(offset, 4):uint()
    payload:add(goria.length, buf(offset, 4))
    offset = offset + 4

    for i=1,length do
      elem = payload:add(goria.a, buf())
      elem:add(goria.subIdx, buf(offset, 4))
      offset = offset + 4

      local dataSize = buf(offset, 4):uint()
      elem:add(goria.dataSize, buf(offset, 4))
      offset = offset + 4
      elem:add(goria.data, buf(offset, dataSize))
      offset = offset + dataSize
    end
  end



  function getObjectFromIDReq(buf, subtree)
    local payload = subtree:add(GET_OBJECT, buf())

    local offset = 0
    payload:add(go.opcode, buf(offset, 2))
    offset = offset + 2
    payload:add(go.vid, buf(offset, 4))
    offset = offset + 4
    payload:add(go.oix, buf(offset, 4))
  end

  function getObjectFromARefReq(buf, subtree)
    local payload = subtree:add(GET_OBJECT, buf())

    local offset = 0
    payload:add(go.opcode, buf(offset, 2))
    offset = offset + 2
    payload:add(go.vid, buf(offset, 4))
    offset = offset + 4
    payload:add(go.oix, buf(offset, 4))
    offset = offset + 4
    payload:add(go.offset, buf(offset, 4))
    offset = offset + 4
    payload:add(go.body, buf(offset, 4))
    offset = offset + 4
    payload:add(go.size, buf(offset, 4))
    offset = offset + 4
    payload:add(go.flags, buf(offset, 4))
  end

  function getObjectFromNameReq(buf, subtree)
    local payload = subtree:add(GET_OBJECT, buf())

    local offset = 0
    payload:add(go.opcode, buf(offset, 2))
    offset = offset + 2
    local nameLen = buf(offset, 4)
    offset = offset + 4
    payload:add(go.nameLen, nameLen)
    payload:add(go.name, buf(offset, nameLen:uint()))
  end

  --Client sends which fields it's interested in
  -- Server sends only those fields
  function getObjectRes(buf, subtree)
    local payload = subtree:add(GET_OBJECT, buf())

    local offset = 0
    payload:add(go.vid, buf(offset, 4))
    offset = offset + 4
    payload:add(go.oix, buf(offset, 4))
    offset = offset + 4
    payload:add(go.cid, buf(offset, 4))
    offset = offset + 4
    payload:add(go.hasChildren, buf(offset, 1))
    offset = offset + 1

    local nameLen = buf(offset, 4):uint()
    payload:add(go.nameLen, buf(offset, 4))
    offset = offset + 4
    if nameLen > 0 then
      payload:add(go.name, buf(offset, nameLen))
      offset = offset + nameLen
    end

    local fullnameLen = buf(offset, 4):uint()
    payload:add(go.fullnameLen, buf(offset, 4))
    offset = offset + 4
    if fullnameLen > 0 then
      payload:add(go.fullname, buf(offset, fullnameLen))
      offset = offset + fullnameLen
    end

    local classnameLen = buf(offset, 4):uint()
    payload:add(go.classnameLen, buf(offset, 4))
    offset = offset + 4
    if classnameLen > 0 then
      payload:add(go.classname, buf(offset, classnameLen))
      offset = offset + classnameLen
    end

    local descLen = buf(offset, 4):uint()
    payload:add(go.descLen, buf(offset, 4))
    offset = offset + 4
    if descLen > 0 then
      payload:add(go.desc, buf(offset, descLen))
      offset = offset + descLen
    end

    local paramLen = buf(offset, 4):uint()
    payload:add(go.paramLen, buf(offset, 4))
    offset = offset + 4
    if paramLen > 0 then
      payload:add(go.param, buf(offset, paramLen))
      offset = offset + paramLen
    end
  end



  function mhSyncReq(buf, subtree)
    local payload = subtree:add(MH_SYNC, buf())
    payload:add(mhsync.sync, buf(0, 4))
  end

  function mhSyncRes(buf, subtree)
    local offset = 0
    local payload = subtree:add(MH_SYNC, buf())

    local arrLen = buf(offset, 4):uint()
    payload:add(mhsync.arrLen, buf(offset, 4))
    offset = offset + 4
    for i=1,arrLen do
      local oldOffset = offset

      local eventTime
      local eventTimeLen = buf(offset, 4)
      offset = offset + 4
      if eventTimeLen:uint() > 0 then
        eventTime = buf(offset, eventTimeLen:uint())
        offset = offset + eventTimeLen:uint()
      end

      local eventText
      local eventTextLen = buf(offset, 4)
      offset = offset + 4
      if eventTextLen:uint() > 0 then
        eventText = buf(offset, eventTextLen:uint())
        offset = offset + eventTextLen:uint()
      end

      local eventName
      local eventNameLen = buf(offset, 4)
      offset = offset + 4
      if eventNameLen:uint() > 0 then
        eventName = buf(offset, eventNameLen:uint())
        offset = offset + eventNameLen:uint()
      end

      local eventFlags = buf(offset, 4)
      offset = offset + 4
      local eventStatus = buf(offset, 4)
      offset = offset + 4
      local eventPrio = buf(offset, 4)
      offset = offset + 4

      -- BEGIN event id
      local offsetBeforeEventId = offset

      local eventIDNix = buf(offset, 4)
      offset = offset + 4
      local eventIDIdx = buf(offset, 4)
      offset = offset + 4
      local eventIDBirthTime
      local eventIDBirthTimeLen = buf(offset, 4)
      offset = offset + 4
      if eventIDBirthTimeLen:uint() > 0 then
        eventIDBirthTime = buf(offset, eventIDBirthTimeLen:uint())
        offset = offset + eventIDBirthTimeLen:uint()
      end

      local eventIdBufSize = offset - offsetBeforeEventId
      -- END event id

      -- BEGIN event target id
      local offsetBeforeEventTargetId = offset

      local eventTargetIDNix = buf(offset, 4)
      offset = offset + 4
      local eventTargetIDIdx = buf(offset, 4)
      offset = offset + 4
      local eventTargetIDBirthTime
      local eventTargetIDBirthTimeLen = buf(offset, 4)
      offset = offset + 4
      if eventTargetIDBirthTimeLen:uint() > 0 then
        eventTargetIDBirthTime = buf(offset, eventTargetIDBirthTimeLen:uint())
        offset = offset + eventTargetIDBirthTimeLen:uint()
      end

      local eventTargetIdBufSize = offset - offsetBeforeEventTargetId
      -- END event target id

      local eventType = buf(offset, 4)
      offset = offset + 4

      -- BEGIN event object
      local offsetBeforeEventObject = offset

      local eventObjectVid = buf(offset, 4)
      offset = offset + 4
      local eventObjectOix = buf(offset, 4)
      offset = offset + 4
      local eventObjectOffset = buf(offset, 4)
      offset = offset + 4
      local eventObjectBody = buf(offset, 4)
      offset = offset + 4
      local eventObjectSize = buf(offset, 4)
      offset = offset + 4
      local eventObjectFlags = buf(offset, 4)
      offset = offset + 4
 
      local eventObjectBufSize = offset - offsetBeforeEventObject
      -- END event object

      -- BEGIN event sup object
      local offsetBeforeEventSupObject = offset

      local eventSupObjectVid = buf(offset, 4)
      offset = offset + 4
      local eventSupObjectOix = buf(offset, 4)
      offset = offset + 4
      local eventSupObjectOffset = buf(offset, 4)
      offset = offset + 4
      local eventSupObjectBody = buf(offset, 4)
      offset = offset + 4
      local eventSupObjectSize = buf(offset, 4)
      offset = offset + 4
      local eventSupObjectFlags = buf(offset, 4)
      offset = offset + 4
 
      local eventSupObjectBufSize = offset - offsetBeforeEventSupObject
      -- END event sup object

      local eventMoreText
      local eventMoreTextLen = buf(offset, 4)
      offset = offset + 4
      if eventMoreTextLen:uint() > 0 then
        eventMoreText = buf(offset, eventMoreTextLen:uint())
        offset = offset + eventMoreTextLen:uint()
      end

      local eventSyncIdx = buf(offset, 4)
      offset = offset + 4

      local event = payload:add(mhsync.events, buf(oldOffset, offset - oldOffset))

      event:add(mhsync.eventTimeLen, eventTimeLen)
      if eventTime then
        event:add(mhsync.eventTime, eventTime)
      end

      event:add(mhsync.eventTextLen, eventTextLen)
      if eventText then
        event:add(mhsync.eventText, eventText)
      end

      event:add(mhsync.eventNameLen, eventNameLen)
      if eventName then
        event:add(mhsync.eventName, eventName)
      end

      event:add(mhsync.eventFlags, eventFlags)
      event:add(mhsync.eventStatus, eventStatus)
      event:add(mhsync.eventPrio, eventPrio)

      local eventID = event:add(mhsync.eventID, buf(offsetBeforeEventId, eventIdBufSize))
      eventID:add(mhsync.eventIDNix, eventIDNix)
      eventID:add(mhsync.eventIDIdx, eventIDIdx)
      eventID:add(mhsync.eventIDBirthTimeLen, eventIDBirthTimeLen)
      if eventIDBirthTime then
        eventID:add(mhsync.eventIDBirthTime, eventIDBirthTime)
      end

      local eventTargetID = event:add(mhsync.eventTargetID, buf(offsetBeforeEventTargetId, eventTargetIdBufSize))
      eventTargetID:add(mhsync.eventTargetIDNix, eventTargetIDNix)
      eventTargetID:add(mhsync.eventTargetIDIdx, eventTargetIDIdx)
      eventTargetID:add(mhsync.eventTargetIDBirthTimeLen, eventTargetIDBirthTimeLen)
      if eventTargetIDBirthTime then
        eventTargetID:add(mhsync.eventTargetIDBirthTime, eventTargetIDBirthTime)
      end

      event:add(mhsync.eventType, eventType)

      local eventObject = event:add(mhsync.eventObject, buf(offsetBeforeEventObject, eventObjectBufSize))
      eventObject:add(mhsync.eventObjectVid, eventObjectVid)
      eventObject:add(mhsync.eventObjectOix, eventObjectOix)
      eventObject:add(mhsync.eventObjectOffset, eventObjectOffset)
      eventObject:add(mhsync.eventObjectBody, eventObjectBody)
      eventObject:add(mhsync.eventObjectSize, eventObjectSize)
      eventObject:add(mhsync.eventObjectFlags, eventObjectFlags)

      local eventSupObject = event:add(mhsync.eventSupObject, buf(offsetBeforeEventSupObject, eventSupObjectBufSize))
      eventSupObject:add(mhsync.eventSupObjectVid, eventSupObjectVid)
      eventSupObject:add(mhsync.eventSupObjectOix, eventSupObjectOix)
      eventSupObject:add(mhsync.eventSupObjectOffset, eventSupObjectOffset)
      eventSupObject:add(mhsync.eventSupObjectBody, eventSupObjectBody)
      eventSupObject:add(mhsync.eventSupObjectSize, eventSupObjectSize)
      eventSupObject:add(mhsync.eventSupObjectFlags, eventSupObjectFlags)

      event:add(mhsync.eventMoreTextLen, eventMoreTextLen)
      if eventMoreText then
        event:add(mhsync.eventMoreText, eventMoreText)
      end

      event:add(mhsync.eventSyncIdx, eventSyncIdx)
    end
  end

  function mhAckReq(buf, subtree)
    local payload = subtree:add(MH_ACK, buf())
    local offset = 0

    payload:add(mhack.nix, buf(offset, 4))
    offset = offset + 4
    payload:add(mhack.idx, buf(offset, 4))
    offset = offset + 4

    local birthTimeLen = buf(offset, 4)
    payload:add(mhack.birthTimeLen, birthTimeLen)
    offset = offset + 4
    payload:add(mhack.birthTime, buf(offset, birthTimeLen:uint()))
  end

  function checkUserReq(buf, subtree)
    local offset = 0
    local payload = subtree:add(CHECK_USER, buf())

    local usernameLen = buf(offset, 4):uint()
    payload:add(cu.usernameLen, buf(offset, 4))
    offset = offset + 4
    if usernameLen > 0 then
      payload:add(cu.username, buf(offset, usernameLen))
    end
    offset = offset + usernameLen

    local passwordLen = buf(offset, 4):uint()
    payload:add(cu.passwordLen, buf(offset, 4))
    offset = offset + 4
    if passwordLen > 0 then
      payload:add(cu.password, buf(offset, passwordLen))
    end
  end

  function checkUserRes(buf, subtree)
    local payload = subtree:add(CHECK_USER, buf())
    payload:add(cu.priv, buf(0, 4))
  end

  function getAllXttChildrenReq(buf, subtree)
    local payload = subtree:add(GET_ALL_XTT_CHILDREN, buf())

    local offset = 0
    payload:add(gaxc.vid, buf(offset, 4))
    offset = offset + 4
    payload:add(gaxc.oix, buf(offset, 4))
  end

  function getAllXttChildrenRes(buf, subtree)
    local offset = 0
    local payload = subtree:add(GET_ALL_XTT_CHILDREN, buf())

    local arrLen = buf(offset, 4):uint()
    payload:add(gaxc.arrLen, buf(offset, 4))
    offset = offset + 4
    for i=1,arrLen do
      local oldOffset = offset
      local childVid = buf(offset, 4)
      offset = offset + 4
      local childOix = buf(offset, 4)
      offset = offset + 4
      local childCid = buf(offset, 4)
      offset = offset + 4
      local childHasChildren = buf(offset, 1)
      offset = offset + 1

      local childName
      local childDesc
      local childClassname

      local childNameLen = buf(offset, 4)
      offset = offset + 4
      if childNameLen:uint() > 0 then
        childName = buf(offset, childNameLen:uint())
        offset = offset + childNameLen:uint()
      end

      local childDescLen = buf(offset, 4)
      offset = offset + 4
      if childDescLen:uint() > 0 then
        childDesc = buf(offset, childDescLen:uint())
        offset = offset + childDescLen:uint()
      end

      local childClassnameLen = buf(offset, 4)
      offset = offset + 4
      if childClassnameLen:uint() > 0 then
        childClassname = buf(offset, childClassnameLen:uint())
        offset = offset + childClassnameLen:uint()
      end

      local elem = payload:add(gaxc.children, buf(oldOffset, offset - oldOffset))
      elem:add(gaxc.childVid, childVid)
      elem:add(gaxc.childOix, childOix)
      elem:add(gaxc.childCid, childCid)
      elem:add(gaxc.childHasChildren, childHasChildren)

      elem:add(gaxc.childNameLen, childNameLen)
      if childName then
        elem:add(gaxc.childName, childName)
      end

      elem:add(gaxc.childDescLen, childDescLen)
      if childDesc then
        elem:add(gaxc.childDesc, childDesc)
      end

      elem:add(gaxc.childClassnameLen, childClassnameLen)
      if childClassname then
        elem:add(gaxc.childClassname, childClassname)
      end
    end
  end

  function getOpWindMenuReq(buf, subtree)
    local offset = 0
    local payload = subtree:add(GET_OPWIND_MENU, buf())

    local opPlaceLen = buf(offset, 4):uint()
    payload:add(gom.placeLen, buf(offset, 4))
    offset = offset + 4
    if opPlaceLen > 0 then
      payload:add(gom.place, buf(offset, opPlaceLen))
    end
  end

  function getOpWindMenuRes(buf, subtree)
    local offset = 0
    local payload = subtree:add(GET_OPWIND_MENU, buf())

    local titleLen = buf(offset, 4):uint()
    payload:add(gom.titleLen, buf(offset, 4))
    offset = offset + 4
    if titleLen > 0 then
      payload:add(gom.title, buf(offset, titleLen))
      offset = offset + titleLen
    end

    local textLen = buf(offset, 4):uint()
    payload:add(gom.textLen, buf(offset, 4))
    offset = offset + 4
    if textLen > 0 then
      payload:add(gom.text, buf(offset, textLen))
      offset = offset + textLen
    end

    payload:add(gom.enableLang, buf(offset, 1))
    offset = offset + 1

    payload:add(gom.enableLogin, buf(offset, 1))
    offset = offset + 1

    payload:add(gom.enableAlarmList, buf(offset, 1))
    offset = offset + 1

    payload:add(gom.enableEventLog, buf(offset, 1))
    offset = offset + 1

    payload:add(gom.enableNavigator, buf(offset, 1))
    offset = offset + 1

    payload:add(gom.disableHelp, buf(offset, 1))
    offset = offset + 1

    payload:add(gom.disableProview, buf(offset, 1))
    offset = offset + 1

    local arrLen = buf(offset, 4):uint()
    payload:add(gom.arrLen, buf(offset, 4))
    offset = offset + 4
    for i=1,arrLen do
      local oldOffset = offset
      local cdhrClassId = buf(offset, 4)
      offset = offset + 4

      local childText
      local childName
      local childUrl

      local childTextLen = buf(offset, 4)
      offset = offset + 4
      if childTextLen:uint() > 0 then
        childText = buf(offset, childTextLen:uint())
        offset = offset + childTextLen:uint()
      end

      local childNameLen = buf(offset, 4)
      offset = offset + 4
      if childNameLen:uint() > 0 then
        childName = buf(offset, childNameLen:uint())
        offset = offset + childNameLen:uint()
      end

      local childUrlLen = buf(offset, 4)
      offset = offset + 4
      if childUrlLen:uint() > 0 then
        childUrl = buf(offset, childUrlLen:uint())
        offset = offset + childUrlLen:uint()
      end

      local elem = payload:add(gom.children, buf(oldOffset, offset - oldOffset))
      elem:add(gom.cdhrClassId, cdhrClassId)

      elem:add(gom.childTextLen, childTextLen)
      if childText then
        elem:add(gom.childText, childText)
      end

      elem:add(gom.childNameLen, childNameLen)
      if childName then
        elem:add(gom.childName, childName)
      end

      elem:add(gom.childUrlLen, childUrlLen)
      if childUrl then
        elem:add(gom.childUrl, childUrl)
      end
    end
  end

  function getAllClassAttributesReq(buf, subtree)
    local payload = subtree:add(GET_ALL_CLASS_ATTRIBUTES, buf())

    local offset = 0
    payload:add(gaca.cid, buf(offset, 4))
    offset = offset + 4
    payload:add(gaca.vid, buf(offset, 4))
    offset = offset + 4
    payload:add(gaca.oix, buf(offset, 4))
  end

  function getAllClassAttributesRes(buf, subtree)
    local offset = 0
    local payload = subtree:add(GET_ALL_CLASS_ATTRIBUTES, buf())

    local arrLen = buf(offset, 4):uint()
    payload:add(gaca.arrLen, buf(offset, 4))
    offset = offset + 4
    for i=1,arrLen do
      local oldOffset = offset
      local childType = buf(offset, 4)
      offset = offset + 4
      local childFlags = buf(offset, 4)
      offset = offset + 4
      local childSize = buf(offset, 2)
      offset = offset + 2
      local childElements = buf(offset, 2)
      offset = offset + 2

      local childName
      local childClassname

      local childNameLen = buf(offset, 4)
      offset = offset + 4
      if childNameLen:uint() > 0 then
        childName = buf(offset, childNameLen:uint())
        offset = offset + childNameLen:uint()
      end

      local childClassnameLen = buf(offset, 4)
      offset = offset + 4
      if childClassnameLen:uint() > 0 then
        childClassname = buf(offset, childClassnameLen:uint())
        offset = offset + childClassnameLen:uint()
      end

      local elem = payload:add(gaca.children, buf(oldOffset, offset - oldOffset))
      elem:add(gaca.childType, childType)
      elem:add(gaca.childFlags, childFlags)
      elem:add(gaca.childSize, childSize)
      elem:add(gaca.childElements, childElements)

      elem:add(gaca.childNameLen, childNameLen)
      if childName then
        elem:add(gaca.childName, childName)
      end

      elem:add(gaca.childClassnameLen, childClassnameLen)
      if childClassname then
        elem:add(gaca.childClassname, childClassname)
      end
    end
  end

  function crrSignalReq(buf, subtree)
    local payload = subtree:add(CRR_SIGNAL, buf())

    local offset = 0
    payload:add(crr.vid, buf(offset, 4))
    offset = offset + 4
    payload:add(crr.oix, buf(offset, 4))
  end

  function crrSignalRes(buf, subtree)
    local offset = 0
    local payload = subtree:add(CRR_SIGNAL, buf())

    local arrLen = buf(offset, 4):uint()
    payload:add(crr.arrLen, buf(offset, 4))
    offset = offset + 4
    for i=1,arrLen do
      local oldOffset = offset
      local childType = buf(offset, 2)
      offset = offset + 2
      local childVid = buf(offset, 4)
      offset = offset + 4
      local childOix = buf(offset, 4)
      offset = offset + 4

      local childName
      local childClassname

      local childNameLen = buf(offset, 4)
      offset = offset + 4
      if childNameLen:uint() > 0 then
        childName = buf(offset, childNameLen:uint())
        offset = offset + childNameLen:uint()
      end

      local childClassnameLen = buf(offset, 4)
      offset = offset + 4
      if childClassnameLen:uint() > 0 then
        childClassname = buf(offset, childClassnameLen:uint())
        offset = offset + childClassnameLen:uint()
      end

      local elem = payload:add(crr.children, buf(oldOffset, offset - oldOffset))
      elem:add(crr.childType, childType)
      elem:add(crr.childVid, childVid)
      elem:add(crr.childOix, childOix)

      elem:add(crr.childNameLen, childNameLen)
      if childName then
        elem:add(crr.childName, childName)
      end

      elem:add(crr.childClassnameLen, childClassnameLen)
      if childClassname then
        elem:add(crr.childClassname, childClassname)
      end
    end
  end

  function getMsgReq(buf, subtree)
    local payload = subtree:add(GET_MESSAGE, buf())
    payload:add(gmt.msgid, buf(0, 4))
  end

  function getMsgRes(buf, subtree)
    local offset = 0
    local payload = subtree:add(GET_MESSAGE, buf())

    local msgTextLen = buf(offset, 4):uint()
    payload:add(gmt.msgTextLen, buf(offset, 4))
    offset = offset + 4
    if msgTextLen > 0 then
      payload:add(gom.msgText, buf(offset, msgTextLen))
    end
  end

  local reqFunctionTable = {
    [1] = setObjectInfoBoolReq,
    [2] = setObjectInfoFloatReq,
    [3] = setObjectInfoIntReq,
    [4] = setObjectInfoStrReq,
    [5] = getObjectInfoReq,
    [6] = getObjectInfoReq,
    [7] = getObjectInfoReq,
    [9] = toggleObjectInfoReq,
    [10] = refObjectInfoReq,
    [15] = unrefObjectInfoReq,
    [29] = checkUserReq,
    [36] = getAllClassAttributesReq,
    [39] = getAllXttChildrenReq,
    [42] = crrSignalReq,
    [50] = getMsgReq,
    [57] = getObjectInfoArrayReq,
    [63] = getObjectFromIDReq,
    [64] = getOpWindMenuReq,
    [65] = getObjectFromNameReq,
    [66] = mhSyncReq,
    [67] = mhAckReq,
    [68] = getObjectFromARefReq
  }

  local resFunctionTable = {
    [5] = getObjectInfoBoolRes,
    [6] = getObjectInfoFloatRes,
    [7] = getObjectInfoIntRes,
    [25] = getObjectRefInfoAllRes,
    [29] = checkUserRes,
    [36] = getAllClassAttributesRes,
    [39] = getAllXttChildrenRes,
    [42] = crrSignalRes,
    [50] = getMsgRes,
    [57] = getObjectInfoFloatArrayRes,
    [63] = getObjectRes,
    [64] = getOpWindMenuRes,
    [65] = getObjectRes,
    [66] = mhSyncRes,
    [68] = getObjectRes
  }

  local t = Field.new("pwr.opcode")
  
  -- websock dissector function
  function pwr.dissector (buf, pinfo, root)
    -- validate packet length is adequate, otherwise quit
    if buf:len() == 0 then return end

    local isReq = pinfo.src_port ~= 4448

    -- create subtree for websock
    subtree = root:add(pwr, buf(0))
    local offset = 0
    -- add protocol fields to subtree
    local protocol_header = subtree:add(PROTOCOL_HEADER, buf(offset,6))
    protocol_header:add(ph.opcode, buf(offset, 1))
    offset = offset + 1
    protocol_header:add(ph.messageID, buf(offset, 4))
    offset = offset + 4;
    local sts = buf(offset, 4):uint()
    protocol_header:add(ph.sts, buf(offset, 4))
    offset = offset + 4

    local messageTypeValue = t().value
    local messageType = messageTypes[messageTypeValue]
    local messageTypeString
    if messageType then
      messageTypeString = "" .. messageType .. "(" .. messageTypeValue .. ")"
      local payloadFunction
      if isReq then
        payloadFunction = reqFunctionTable[messageTypeValue]
      else
        if (sts % 2 == 1) then
          payloadFunction = resFunctionTable[messageTypeValue]
        end
      end
      if payloadFunction then
        local dataLength = buf:len() - offset
        payloadFunction(buf(offset, dataLength), subtree)
      end
    else
      messageTypeString = messageTypeValue
      local dataLength = buf:len() - offset
      local payload = subtree:add(PAYLOAD, buf(offset, dataLength))
      payload:add(pl.data, buf(offset, dataLength))
      offset = offset + dataLength
    end
    pinfo.cols.protocol = pwr.name
    pinfo.cols.info = messageTypeString
  end
  
  -- register a chained dissector for port 8002
  local ws_dissector_table = DissectorTable.get("ws.port")
  ws_dissector_table:add(4448, pwr)
end
