import * as chokidar  from 'chokidar';
import { exec } from 'child_process';

const publishAndUpdate = () => {
  exec('yarn build', (err) => {
    if (!err) {
      console.log('Build successful');
      exec('npx yalc push', (err) => {
        if (err) {
          console.error('yalc push failed:', err);
          return;
        }
        console.log('yalc push successful');
      });
    } else {
      console.error('Build failed:', err);
    }
  })
};

const watcher = chokidar.watch(['ios', 'android', 'js', './package.json'], {
  ignored: /(^|[\/\\])\../, // Ignore dotfiles
  persistent: true,
});

watcher
  .on('change', (path) => {
    console.log(`File ${path} has been changed`);
    publishAndUpdate();
  })
  .on('unlink', (path) => {
    console.log(`File ${path} has been removed`);
    publishAndUpdate();
  });

publishAndUpdate();
