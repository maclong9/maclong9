<script lang="ts">
	import Navigation from '$lib/components/layout/navigation.svelte';
	import PostCard from '$lib/components/post-card.svelte';
	import config from '$lib/config';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
</script>

<section id="about" class="mb-12">
	<h2>Hi, I'm Mac 👋</h2>
	<p>{config.metadata.description}</p>
	<p class="mb-2">Feel free to reach out:</p>
	<Navigation withLabel />
</section>

<section id="posts">
	<h2 class="mb-4">Latest Posts</h2>
	<div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
		{#each data.posts as post (post.path)}
			<PostCard {...post} />
		{/each}
	</div>
</section>
