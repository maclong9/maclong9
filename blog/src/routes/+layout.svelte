<script lang="ts">
	import { page } from '$app/state';
	import { routeToSentenceCase } from '$lib';
	import Navigation from '$lib/components/layout/navigation.svelte';
	import config from '$lib/config';
	import { ModeWatcher } from 'mode-watcher';
	import '../app.css';

	let { children } = $props();

	const pageTitle = `${routeToSentenceCase(page.url.pathname)} | ${config.app.shortName}`;
</script>

<svelte:head>
	<title>{pageTitle}</title>
	<meta name="description" content={config.metadata.description} />

	<!-- OpenGraph -->
	<meta property="og:title" content={pageTitle} />
	<meta property="og:description" content={config.metadata.description} />

	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image" />
</svelte:head>

<ModeWatcher />

<header class="mb-4 flex items-center justify-between">
	<a href={page.url.pathname.includes('/posts') ? '/#posts' : '/'}>
		<h1 class="my-0 font-bold">
			{config.app.shortName}
		</h1>
	</a>
	<Navigation />
</header>

<main class="min-h-[calc(100dvh-9rem)]">
	{@render children()}
</main>

<footer class="mt-auto">
	<hr class="my-4" />
	<div class="text-surface-500 flex justify-between text-sm">
		<div>© {new Date().getFullYear()} {config.app.shortName}</div>
		<Navigation />
	</div>
</footer>
