# Hot Girl Schedule 💗

A one-tap, whole-day time tracker: switch activities with one tap, log what you did *while* on a shift, drill, commute or gym session, compare your planned schedule with what actually happened, and see where your hours go on a dashboard.

**Stack:** one static `index.html` (HTML, CSS, vanilla JS) hosted on GitHub Pages, with Supabase for login, storage and live sync across devices.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole app |
| `schema.sql` | The database table plus Row Level Security policies |
| `manifest.webmanifest`, `icon.png` | Home-screen app name and icon |

## Setup

### 1. Supabase project
1. Create a free project at [supabase.com](https://supabase.com).
2. Open **SQL Editor ▸ New query**, paste in all of `schema.sql`, and click **Run**.
3. Open **Authentication ▸ Users ▸ Add user ▸ Create new user**. Enter your email and a password, and check **Auto Confirm User**.
4. In the Authentication settings, turn off **Allow new users to sign up**. That way you're the only account that can ever exist.

### 2. Connect the app
1. In **Project Settings ▸ API** (on newer dashboards it may be **Data API** or **API Keys**), copy the **Project URL** and the **anon** / **publishable** key.
2. Paste both into the top of the `<script>` in `index.html`:
   ```js
   const SUPABASE_URL = "https://xxxx.supabase.co";
   const SUPABASE_ANON_KEY = "your-anon-or-publishable-key";
   ```
   This key is meant to be public. Row Level Security is what protects your data: every row can only be read or written by the user who owns it.

### 3. GitHub Pages
1. Create a repo (for example `hot-pink-hours`) and push all four files to `main`.
2. In the repo, go to **Settings ▸ Pages ▸ Build and deployment**, choose **Deploy from a branch**, and pick **main** and **/ (root)**.
3. After about a minute, the app is live at `https://<username>.github.io/hot-pink-hours/`.

> On a free GitHub account, Pages requires a **public** repo. Private repos need GitHub Pro, which is included in the GitHub Student Developer Pack.

### 4. First run
1. Open the URL and sign in.
2. Tap **Set up my defaults**. This loads your activities, projects and class/gym/tutoring schedule.
3. Moving from the Claude-hosted version? Export a CSV there (**Setup ▸ Export CSV**), then use **Setup ▸ Import CSV** here. Entries that already exist are skipped.
4. Add it to your home screen: in Safari, tap **≡ ▸ Share ▸ Add to Home Screen**.

## How the data is stored

There is a single table, `docs`, with one row per document:

| kind | key | data |
|---|---|---|
| `config` | `main` | activities, "while" options, projects, schedule, one-off blocks |
| `dueouts` | `main` | `{ items: [...] }` |
| `day` | `YYYY-MM-DD` | `{ entries: [...], subs: [...] }`, the main timeline and the "while" layer for entries that started that day |

Timestamps are epoch milliseconds. A running entry has `end: null`. Live sync uses Supabase Realtime on `docs`, and the app also reloads whenever it comes back to the foreground. A heavy day is about 6 KB, so the free tier's 500 MB lasts a very long time.

**Free-tier note:** Supabase pauses free projects after about a week with no activity. Daily use keeps the project awake. If it does pause, click **Restore** in the dashboard.
