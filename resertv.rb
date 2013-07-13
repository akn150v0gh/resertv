#!/usr/bin/env ruby
# coding: utf-8

require 'cgi'
require 'net/smtp'

config = {
  :from      => 'me@example.com',
  :to        => 'tv@example.com',
  :password  => 'PASSWORD',
  :recorder  => 'U1',
  :multiplex => 'MS',
  :smtp_host => 'localhost',
  :smtp_port => 25,
}

channels = [
  ['TD011', 'NHK総合'],
  ['TD020', '東京MX'],
  ['TD021', 'NHK Eテレ'],
  ['TD028', '放送大学'],
  ['TD041', '日本テレビ'],
  ['TD061', 'TBSテレビ'],
  ['TD081', 'フジテレビ'],
  ['TD051', 'テレビ朝日'],
  ['TD071', 'テレビ東京'],
  ['BS101', 'NHK BS1'],
  ['BS103', 'NHK BSプレミアム'],
  ['BS141', 'BS日テレ'],
  ['BS151', 'BS朝日'],
  ['BS161', 'BS-TBS'],
  ['BS171', 'BSジャパン'],
  ['BS181', 'BSフジ'],
  ['BS191', 'WOWOWプライム'],
  ['BS192', 'WOWOWライブ'],
  ['BS193', 'WOWOWシネマ'],
  ['BS200', 'スター・チャンネル1'],
  ['BS201', 'スター・チャンネル2'],
  ['BS202', 'スター・チャンネル3'],
  ['BS211', 'BS11デジタル'],
  ['BS222', 'TwellV（トゥエルビ）'],
  ['BS231', '放送大学テレビ'],
  ['BS232', '放送大学テレビ2'],
  ['BS233', '放送大学テレビ3'],
  ['BS234', 'グリーンチャンネル'],
  ['BS236', 'BSアニマックス'],
  ['BS238', 'FOX bs238'],
  ['BS241', 'BSスカパー！'],
  ['BS242', 'J SPORTS 1'],
  ['BS243', 'J SPORTS 2'],
  ['BS244', 'J SPORTS 3'],
  ['BS245', 'J SPORTS 4'],
  ['BS251', 'BS釣りビジョン'],
  ['BS252', 'IMAGICA BS'],
  ['BS255', 'BS日本映画専門チャンネル'],
  ['BS256', 'ディズニー・チャンネル'],
  ['BS258', 'Dlife'],
  ['CS055', 'ショップ チャンネル'],
  ['CS100', 'スカパー！プロモ100'],
  ['CS161', 'QVC'],
  ['CS218', '東映チャンネル'],
  ['CS219', '衛星劇場'],
  ['CS223', 'チャンネルNECO'],
  ['CS227', 'ザ・シネマ'],
  ['CS229', 'FOXムービー プレミアム'],
  ['CS240', 'ムービープラスHD'],
  ['CS250', 'スカイ・A sports＋'],
  ['CS254', 'GAORA'],
  ['CS257', '日テレG+ HD'],
  ['CS262', 'ゴルフネットワークHD'],
  ['CS290', 'TAKARAZUKA SKY STAGE'],
  ['CS292', '時代劇専門チャンネルHD'],
  ['CS293', 'ファミリー劇場HD'],
  ['CS294', 'ホームドラマチャンネル'],
  ['CS296', 'TBSチャンネル1'],
  ['CS297', 'TBSチャンネル2'],
  ['CS298', 'テレ朝チャンネルHD'],
  ['CS299', '朝日ニュースターHD'],
  ['CS300', '日テレプラス'],
  ['CS305', 'チャンネル銀河'],
  ['CS307', 'フジテレビONE スポーツ・バラエティ'],
  ['CS308', 'フジテレビTWO ドラマ・アニメ'],
  ['CS309', 'フジテレビNEXT ライブ・プレミアム'],
  ['CS310', 'スーパー！ドラマTV HD'],
  ['CS311', 'AXN'],
  ['CS312', 'FOX'],
  ['CS314', '女性チャンネル♪LaLa TV(HD)'],
  ['CS321', '100%ヒッツ！スペースシャワーTVプラス'],
  ['CS322', 'スペースシャワーTV'],
  ['CS323', 'MTV HD'],
  ['CS325', 'MUSIC ON! TV（エムオン！）HD'],
  ['CS326', 'ミュージック・エア'],
  ['CS329', '歌謡ポップスチャンネル'],
  ['CS330', 'キッズステーションHD'],
  ['CS331', 'カートゥーン ネットワーク'],
  ['CS333', 'アニメシアターX (AT-X)'],
  ['CS339', 'ディズニージュニア'],
  ['CS340', 'ディスカバリーチャンネル'],
  ['CS341', 'アニマルプラネット'],
  ['CS342', 'ヒストリーチャンネル'],
  ['CS343', 'ナショナル ジオグラフィック チャンネル'],
  ['CS349', '日テレNEWS24'],
  ['CS351', 'TBSニュースバード'],
  ['CS353', 'BBCワールドニュース'],
  ['CS354', 'CNNj'],
  ['CS362', '旅チャンネル'],
  ['CS363', '囲碁・将棋チャンネル'],
  ['CS800', 'スカチャン0'],
  ['CS801', 'スカチャン1'],
  ['CS802', 'スカチャン2'],
  ['CS805', 'スカチャン3'],
]

cgi = CGI.new

if cgi.request_method == 'POST'

  if cgi['date'] =~ /^\d{8}$/ &&
    cgi['start'] =~ /^\d{4}$/ && cgi['stop'] =~ /^\d{4}$/ &&
    cgi['start'].to_i < cgi['stop'].to_i

    data = "dtvopen #{config[:password]} #{cgi['date']} " +
      "#{cgi['start']} #{cgi['stop']} #{cgi['channel']} " +
      "#{cgi['recorder']} #{cgi['multiplex']}"
    mailbody = "From: #{config[:from]}\n" +
      "To: #{config[:to]}\n" +
      "Cc: #{config[:from]}\n" +
      "Subject: recording reservation\n" +
      "\n" +
      "#{data}\n"
    Net::SMTP.start(config[:smtp_host], config[:smtp_port]) {|smtp|
        smtp.send_mail(mailbody, config[:from],
          [config[:to], config[:from]])
    }

    html = <<-_END
      <!DOCTYPE html>
      <html lang="ja">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>録画予約</title>
      </head>
      <body>
        <h1>録画予約</h1>
        <p>録画予約を送信しました</p>
        <p><a href="resertv.rb">戻る</a></p>
      </body>
      </html>
    _END

  else

    html = <<-_END
      <!DOCTYPE html>
      <html lang="ja">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>録画予約</title>
      </head>
      <body>
        <h1>エラー</h1>
        <p>日時指定に問題があります。</p>
        <p><a href="resertv.rb">戻る</a></p>
      </body>
      </html>
    _END

  end

else

  today = Time.now
  day = today.strftime('%Y%m%d')
  start = (today+3600).strftime('%H') + '00'
  stop = (today+7200).strftime('%H') + '00'
  channels_select = ""
  channels.each {|ch|
    channels_select << %Q{<option value="#{ch[0]}">#{ch[0]}: #{ch[1]}</option>}
  }

  html = <<-_END
  <!DOCTYPE html>
  <html lang="ja">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>録画予約</title>
  </head>
  <body>
    <h1>録画予約</h1>
    <form method="post" action="resertv.rb">
      <input type="hidden" name="recorder" value="#{config[:recorder]}">
      <input type="hidden" name="multiplex" value="#{config[:multiplex]}">
      日付：<input type="text" name="date" size="10" maxlength="8"
      istyle="4" mode="numeric" value="#{day}"><br>
      時刻：<input type="text" name="start" size="5" maxlength="4"
      istyle="4" mode="numeric" value="#{start}">
      〜 <input type="text" name="stop" size="5" maxlength="4"
      istyle="4" mode="numeric" value="#{stop}"><br>
      チャンネル：
      <select name="channel">
        #{channels_select}
      </select>
      <br>
      <input type="submit" value="予約">
    </form>
  </body>
  </html>
  _END

end

cgi.out({'charset'=>'utf-8'}) {html}
