<script lang="ts">
	import { Heart, Clock } from 'lucide-svelte';
	import {
		Card,
		CardContent,
		CardDescription,
		CardFooter,
		CardHeader,
		CardTitle
	} from '$lib/components/ui/card';
	import { Button } from '$lib/components/ui/button';
	import { Avatar, AvatarFallback, AvatarImage } from '$lib/components/ui/avatar';

	let { path, image, title, category, description, likes, readTime, published } = $props<{
		path: string;
		image: string;
		title: string;
		category: string;
		description: string;
		likes: number;
		readTime: number;
		published: string;
	}>();
</script>

<Card class="w-full max-w-sm">
	<CardHeader>
		<img
			src={image || '/placeholder.svg'}
			alt={title}
			class="h-48 w-full rounded-t-lg object-cover"
		/>
		<CardTitle>{title}</CardTitle>
		<CardDescription>{category}</CardDescription>
	</CardHeader>
	<CardContent>
		<p class="text-sm text-gray-600">{description}</p>
	</CardContent>
	<CardFooter class="flex items-center justify-between">
		<div class="flex items-center space-x-2">
			<Button variant="ghost" size="icon">
				<Heart class="mr-1 h-4 w-4" />
				<span>{likes}</span>
			</Button>
			<div class="flex items-center text-sm text-gray-500">
				<Clock class="mr-1 h-4 w-4" />
				<span>{readTime} min read</span>
			</div>
		</div>
		<div class="text-sm text-gray-500">
			{new Date(published).toISOString()}
		</div>
	</CardFooter>
</Card>`
