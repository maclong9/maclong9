<script lang="ts">
	import Navigation from '$lib/components/navigation.svelte';
	import PostCard from '$lib/components/post-card.svelte';
	import config from '$lib/config';
	import type { PageProps } from './$types';
	let { data }: PageProps = $props();
</script>

<section id="about" class="mb-12">
	<h2>Hi, I'm Mac 👋</h2>
	<p>{config.metadata.description}</p>
	<p class="mb-2">Feel free to reach out:</p>
	<Navigation withLabel />
</section>

<section id="posts">
	<h2 class="mb-4">Latest Posts</h2>
	<div class="grid gap-4">
		<PostCard
			path="/posts/hello-world"
			image="https://source.unsplash.com/random/800x600"
			title="Hello World"
			category="Web"
			description="This is a description of the post"
			likes={10}
			readTime={5}
			published={new Date().toISOString()}
		/>
	</div>
</section>
